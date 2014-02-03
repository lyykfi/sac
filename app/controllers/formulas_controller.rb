class FormulasController < ApplicationController
  helper_method :sort_column, :sort_direction
  respond_to :html, :json, :js, :xml

	def index
    params[:page] && params[:page].to_i > 0 ? params[:page] : 1

    @editable = (params[:editable] == "true")

    @formulas = Formula.order(sort_column + " " + sort_direction).paginate(page: params[:page])
    @formulas = @formulas.where("name LIKE ?", "%#{params[:search]}%") if params[:search]
    @formulas = FormulaDecorator.decorate_collection(@formulas)
    @formulas = PaginatingDecorator.new(@formulas)

    respond_to do |format|
      format.html
      format.json {render json: @formulas.decorated_collection, only: [:id, :name]}
      format.xml {render xml: @formulas.decorated_collection, only: [:id, :name]}
      format.js
      format.csv {send_data Formula.to_csv_xls(:csv), type: 'text/csv; charset=cp-1251; header=present', disposition: "attachment; filename=formulas.csv"}
      format.xls {send_data Formula.to_csv_xls(:xls), type: 'text/xls; charset=cp-1251; header=present', disposition: "attachment; filename=formulas.xls"}
    end
	end

	# GET /formulas/1
	# GET /formulas/1.json
	def show
		@formulas = Formula.find(params[:id])

		respond_to do |format|
			format.html
			format.json {render json: @formulas, only: [:id, :name, :short_name, :position]}
		end
	end

  def new
    @formula = Formula.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @formula = Formula.new(params[:formula])
    @formula.save

    respond_to do |format|
      format.js
    end
  end

  def update
    @formula = Formula.find(params[:id])

    @formula.update_attributes(params[:formula])
    respond_with @formula
  end

  def destroy
    error_ids = safe_destroy(params[:ids].split(','))
    error_names = Formula.find(error_ids).map{|p| p.name}

    respond_to do |format|
      format.html
      format.js {render 'formulas/destroy', locals: {error_names: error_names, error_ids: error_ids}}
    end
  end

	def import
		Formula.import(params[:file])
		redirect_to root_url
  end

  private
    def sort_column
      default_value = "created_at"

      Formula.column_names.include?(params[:sort]) ? params[:sort] : default_value
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end
