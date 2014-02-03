class ParametersController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [
                                                  :names_by_subject_ids_and_year,
                                                  :table_by_subject_ids_and_parameter_ids_and_year,
                                                  :chart_by_subject_ids_and_parameter_ids_and_years]
  helper_method :sort_column, :sort_direction
  respond_to :html, :json, :js, :xml

  def index
    params[:page] && params[:page].to_i > 0 ? params[:page] : 1

    @editable = (params[:editable] == "true")

    case sort_column
      when 'group_id' then @parameters = Parameter.sort_by(association: :group, field: :short_name, sort_direction: sort_direction.to_sym).paginate(page: params[:page])
      when 'uom_id' then @parameters = Parameter.sort_by(association: :uom, field: :name, sort_direction: sort_direction.to_sym).paginate(page: params[:page])
      when 'formula_id' then @parameters = Parameter.sort_by(association: :formula, field: :name, sort_direction: sort_direction.to_sym).paginate(page: params[:page])
      else @parameters = Parameter.order(sort_column + " " + sort_direction).paginate(page: params[:page])
    end
    #@parameters = @parameters.where("position LIKE ? OR name LIKE ? OR short_name LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%") if params[:search]
    @parameters = @parameters.filtered_by(associations: [
                                                      {name: :parameter, field: :position},
                                                      {name: :parameter, field: :name},
                                                      {name: :parameter, field: :short_name},
                                                      {name: :group, field: :short_name},
                                                      {name: :uom, field: :name}
                                        ], search_condition: params[:search]) if params[:search]
    @parameters = ParameterDecorator.decorate_collection(@parameters)
    @parameters = PaginatingDecorator.new(@parameters)

    respond_to do |format|
      format.html
      format.json {render json: @parameters.decorated_collection}
      format.xml {render xml: @parameters.decorated_collection}
      format.js
      format.csv {send_data Parameter.to_csv_xls(:csv), type: 'text/csv; charset=cp-1251; header=present', disposition: "attachment; filename=parameters.csv"}
      format.xls {send_data Parameter.to_csv_xls(:xls), type: 'text/xls; charset=cp-1251; header=present', disposition: "attachment; filename=parameters.xls"}
    end
  end

  def show
    @parameter = Parameter.find(params[:id])

    respond_to do |format|
      format.html
      format.json {render json: @parameter}
    end

  end

  def new
    @parameter = Parameter.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @parameter = Parameter.new(params[:parameter])
    @parameter.save

    respond_to do |format|
      format.js
    end
  end

  def update
    @parameter = Parameter.find(params[:id])

    @parameter.update_attributes(params[:parameter])
    respond_with @parameter
  end

  def destroy
    error_ids = safe_destroy(params[:ids].split(','))
    error_names = Parameter.find(error_ids).map{|p| p.short_name}

    respond_to do |format|
      format.html
      format.js {render 'parameters/destroy', locals: {error_names: error_names, error_ids: error_ids}}
    end
  end

  def import
    Parameter.import(params[:file])
    redirect_to root_url
  end

  def vals_by_id_and_year
    render json: Parameter.vals_by_id_and_year( params[:id], params[:year] )
  end

  def names_by_subject_ids_and_year
    render json: Parameter.names_by_subject_ids_and_year( params[:subject_ids], params[:year] )
  end

  def uom_name_by_id
    render json: Parameter.uom_name_by_id( params[:id] )
  end

  def table_by_subject_ids_and_parameter_ids_and_year
    render json: ParamVal.table_by_subject_ids_and_parameter_ids_and_year( params[:subject_ids], params[:parameter_ids], params[:year] )
  end

  def chart_by_subject_ids_and_parameter_ids_and_years
    render json: ParamVal.chart_by_subject_ids_and_parameter_ids_and_years( params[:subject_ids], params[:parameter_ids], params[:year1], params[:year2] )
  end

  private
    def sort_column
      default_value = "created_at"

      Parameter.column_names.include?(params[:sort]) ? params[:sort] : default_value
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end
