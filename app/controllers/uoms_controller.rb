class UomsController < ApplicationController
  helper_method :sort_column, :sort_direction
  respond_to :html, :json, :js, :xml

  def index
    params[:page] && params[:page].to_i > 0 ? params[:page] : 1

    @editable = (params[:editable] == "true")

    @uoms = Uom.order(sort_column + " " + sort_direction).paginate(page: params[:page])

    @uoms = @uoms.filtered_by(associations: [{name: :uom, field: :name}], search_condition: params[:search]) if params[:search]
    @uoms = UomDecorator.decorate_collection(@uoms)
    @uoms = PaginatingDecorator.new(@uoms)

    respond_to do |format|
      format.html
      format.json {render json: @uoms.decorated_collection}
      format.xml {render xml: @uoms.decorated_collection}
      format.js
      format.csv {send_data Uom.to_csv_xls(:csv), type: 'text/csv; charset=cp-1251; header=present', disposition: "attachment; filename=uoms.csv"}
      format.xls {send_data Uom.to_csv_xls(:xls), type: 'text/xls; charset=cp-1251; header=present', disposition: "attachment; filename=uoms.xls"}
    end
  end

  def show
    @uom = Uom.find(params[:id])

    respond_to do |format|
      format.html
      format.json {render json: @uom}
    end

  end

  def new
    @uom = Uom.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @uom = Uom.new(params[:uom])
    @uom.save

    respond_to do |format|
      format.js
    end
  end

  def update
    @uom = Uom.find(params[:id])

    @uom.update_attributes(params[:uom])
    respond_with @uom
  end

  def destroy
    error_ids = safe_destroy(params[:ids].split(','))
    error_names = Uom.find(error_ids).map{|p| p.name}

    respond_to do |format|
      format.html
      format.js {render 'uoms/destroy', locals: {error_names: error_names, error_ids: error_ids}}
    end
  end

  def import
    Uom.import(params[:file])
    redirect_to root_url
  end

  private
  def sort_column
    default_value = "created_at"

    Uom.column_names.include?(params[:sort]) ? params[:sort] : default_value
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
