class ParamValsController < ApplicationController
  helper_method :sort_column, :sort_direction
  respond_to :html, :json, :js, :xml

  def index
    params[:page] && params[:page].to_i > 0 ? params[:page] : 1

    @editable = (params[:editable] == "true")

    case sort_column
      when 'parameter_id' then @param_vals = ParamVal.sort_by(association: :parameter, field: :short_name, sort_direction: sort_direction.to_sym).paginate(page: params[:page])
      when 'subject_id' then @param_vals = ParamVal.sort_by(association: :subject, field: :short_name, sort_direction: sort_direction.to_sym).paginate(page: params[:page])
      else @param_vals = ParamVal.order(sort_column + " " + sort_direction).paginate(page: params[:page])
    end

    @param_vals = @param_vals.filtered_by(associations: [
        {name: :parameter, field: :short_name},
        {name: :subject, field: :short_name},
        {name: :param_val, field: :date_time},
        {name: :param_val, field: :val_numeric},
        {name: :param_val, field: :val_string}
    ], search_condition: params[:search]) if params[:search]
    @param_vals = ParamValDecorator.decorate_collection(@param_vals)
    @param_vals = PaginatingDecorator.new(@param_vals)

    respond_to do |format|
      format.html
      format.json {render json: @param_vals.decorated_collection}
      format.xml {render xml: @param_vals.decorated_collection}
      format.js
      format.csv {send_data ParamVal.to_csv_xls(:csv), type: 'text/csv; charset=cp-1251; header=present', disposition: "attachment; filename=param_vals.csv"}
      format.xls {send_data ParamVal.to_csv_xls(:xls), type: 'text/xls; charset=cp-1251; header=present', disposition: "attachment; filename=param_vals.xls"}
    end
  end

  def show
    @param_val = ParamVal.find(params[:id])

    respond_to do |format|
      format.html
      format.json {render json: @param_val}
    end

  end

  def new
    @param_val = ParamVal.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @param_val = ParamVal.new(params[:param_val])
    @param_val.save

    respond_to do |format|
      format.js
    end
  end

  def update
    @param_val = ParamVal.find(params[:id])

    @param_val.update_attributes(params[:param_val])
    respond_with @param_val
  end

  def destroy
    error_ids = safe_destroy(params[:ids].split(','))
    error_names = ParamVal.find(error_ids).map{|p| p.short_name}

    respond_to do |format|
      format.html
      format.js {render 'param_vals/destroy', locals: {error_names: error_names, error_ids: error_ids}}
    end
  end

  def of_parameter
    render json: ParamVal.in_parameter_ids(params[:param_id])
  end

  def of_year
    render json: ParamVal.of_year(params[:year])
  end

  def less_than_date
    render json: ParamVal.less_than_or_equal_to_date(params[:date])
  end

  def grater_than_date
    render json: ParamVal.grater_than_or_equal_to_date(params[:date])
  end

  def between_dates
    render json: ParamVal.between_dates(params[:start_date], params[:end_date])
  end

  def of_subject
    render json: ParamVal.in_subject_ids(params[:subject_id])
  end

  def of_subject_with_children
    render json: ParamVal.of_subject_with_children(params[:subject_id])
  end

  def of_all_regions
    render json: ParamVal.in_subject_ids(Subject.regions.ids)
  end

  def of_group
    render json: ParamVal.of_group(params[:group_id])
  end

  def available_years
    render json: ParamVal.available_years
  end

  def get_cube
    if params[:year]
      render json: ParamVal.get_cube([params[:year].to_i])
    else
      render json: ParamVal.get_cube
    end
  end

  def import
    ParamVal.import(params[:file])
    redirect_to root_url
  end

  def by_param_id_and_subjects_with_children_and_year
    render json: ParamVal.by_param_id_and_subjects_with_children_and_year(params[:param_id], params[:subject_id], params[:year])
  end

  private

    def sort_column
      default_value = "updated_at"
      ParamVal.column_names.include?(params[:sort]) ? params[:sort] : default_value
    end
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

end
