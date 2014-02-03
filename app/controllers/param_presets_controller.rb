class ParamPresetsController < ApplicationController
  helper_method :sort_column, :sort_direction
  respond_to :html, :json, :js, :xml

  def index
    params[:page] && params[:page].to_i > 0 ? params[:page] : 1

    @editable = (params[:editable] == "true")

    case sort_column
      when 'parameter_id' then @param_presets = ParamPreset.sort_by(association: :parameter, field: :short_name, sort_direction: sort_direction.to_sym).paginate(page: params[:page])
      when 'subject_id' then @param_presets = ParamPreset.sort_by(association: :subject, field: :short_name, sort_direction: sort_direction.to_sym).paginate(page: params[:page])
      else @param_presets = ParamPreset.order(sort_column + " " + sort_direction).paginate(page: params[:page])
    end

    @param_presets = @param_presets.filtered_by(associations: [
        {name: :param_preset, field: :down_preset},
        {name: :param_preset, field: :up_preset},
        {name: :param_preset, field: :date_time},
        {name: :parameter, field: :short_name},
        {name: :subject, field: :short_name}
    ], search_condition: params[:search]) if params[:search]
    @param_presets = ParamPresetDecorator.decorate_collection(@param_presets)
    @param_presets = PaginatingDecorator.new(@param_presets)

    respond_to do |format|
      format.html
      format.json {render json: @param_presets.decorated_collection}
      format.xml {render xml: @param_presets.decorated_collection}
      format.js
      format.csv {send_data ParamPreset.to_csv_xls(:csv), type: 'text/csv; charset=cp-1251; header=present', disposition: "attachment; filename=param_levels.csv"}
      format.xls {send_data ParamPreset.to_csv_xls(:xls), type: 'text/xls; charset=cp-1251; header=present', disposition: "attachment; filename=param_levels.xls"}
    end
  end

  def show
    @param_preset = ParamPreset.find(params[:id])

    respond_to do |format|
      format.html
      format.json {render json: @param_preset}
    end

  end

  def new
    @param_preset = ParamPreset.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @param_preset = ParamPreset.new(params[:param_preset])
    @param_preset.save

    respond_to do |format|
      format.js
    end
  end

  def update
    @param_preset = ParamPreset.find(params[:id])

    @param_preset.update_attributes(params[:param_preset])
    respond_with @param_preset
  end

  def destroy
    error_ids = safe_destroy(params[:ids].split(','))
    error_names = ParamPreset.find(error_ids).map{|p| p.short_name}

    respond_to do |format|
      format.html
      format.js {render 'param_presets/destroy', locals: {error_names: error_names, error_ids: error_ids}}
    end
  end

  def import
    ParamPreset.import(params[:file])
    redirect_to root_url
  end

  private
  def sort_column
    default_value = "created_at"

    ParamPreset.column_names.include?(params[:sort]) ? params[:sort] : default_value
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
