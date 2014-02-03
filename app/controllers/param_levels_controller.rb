class ParamLevelsController < ApplicationController
  helper_method :sort_column, :sort_direction
  respond_to :html, :json, :js, :xml

  def index
    params[:page] && params[:page].to_i > 0 ? params[:page] : 1

    @editable = (params[:editable] == "true")

    case sort_column
      when 'parameter_id' then @param_levels = ParamLevel.sort_by(association: :parameter, field: :short_name, sort_direction: sort_direction.to_sym).paginate(page: params[:page])
      when 'subject_id' then @param_levels = ParamLevel.sort_by(association: :subject, field: :short_name, sort_direction: sort_direction.to_sym).paginate(page: params[:page])
      else @param_levels = ParamLevel.order(sort_column + " " + sort_direction).paginate(page: params[:page])
    end

    @param_levels = @param_levels.filtered_by(associations: [
        {name: :param_level, field: :down_level},
        {name: :param_level, field: :up_level},
        {name: :param_level, field: :color},
        {name: :parameter, field: :short_name},
        {name: :subject, field: :short_name}
    ], search_condition: params[:search]) if params[:search]
    @param_levels = ParamLevelDecorator.decorate_collection(@param_levels)
    @param_levels = PaginatingDecorator.new(@param_levels)

    respond_to do |format|
      format.html
      format.json {render json: @param_levels.decorated_collection}
      format.xml {render xml: @param_levels.decorated_collection}
      format.js
      format.csv {send_data ParamLevel.to_csv_xls(:csv), type: 'text/csv; charset=cp-1251; header=present', disposition: "attachment; filename=param_levels.csv"}
      format.xls {send_data ParamLevel.to_csv_xls(:xls), type: 'text/xls; charset=cp-1251; header=present', disposition: "attachment; filename=param_levels.xls"}
    end
  end

  def show
    @param_level = ParamLevel.find(params[:id])

    respond_to do |format|
      format.html
      format.json {render json: @param_level}
    end

  end

  def new
    @param_level = ParamLevel.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @param_level = ParamLevel.new(params[:param_level])
    @param_level.save

    respond_to do |format|
      format.js
    end
  end

  def update
    @param_level = ParamLevel.find(params[:id])

    @param_level.update_attributes(params[:param_level])
    respond_with @param_level
  end

  def destroy
    error_ids = safe_destroy(params[:ids].split(','))
    error_names = ParamLevel.find(error_ids).map{|p| p.short_name}

    respond_to do |format|
      format.html
      format.js {render 'param_levels/destroy', locals: {error_names: error_names, error_ids: error_ids}}
    end
  end

  def import
    ParamLevel.import(params[:file])
    redirect_to root_url
  end


  def levels
    @param_levels = ParamLevel.by_param_id_and_subject_id(params[:param_id], params[:subject_id])
    render json: @param_levels
  end

  private
    def sort_column
      default_value = "created_at"

      ParamLevel.column_names.include?(params[:sort]) ? params[:sort] : default_value
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end
