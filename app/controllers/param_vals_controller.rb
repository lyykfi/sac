class ParamValsController < ApplicationController
  helper_method :sort_column, :sort_direction
  respond_to :html, :json, :js, :xml

  # GET /param_vals
  # GET /param_vals.json

  
  def index
    params[:page] && params[:page].to_i > 0 ? params[:page] : 1

    @param_vals = !params[:year] ? ParamVal.select('*') : ParamVal.where('year == ?', params[:year])

    @param_vals = @param_vals.where("subject_id LIKE ? OR val_numeric LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%") if params[:search]
    @param_vals = @param_vals.order(sort_column + " " + sort_direction).paginate(page: params[:page])
    @editable = params[:editable] == "true"

    respond_to do |format|
      format.html
      format.json {render json: @param_vals}
      format.js 
    end
  end
  
  # GET /param_vals/1
  # GET /param_vals/1.json
  def show
    @param_val = ParamVal.find(params[:id])

    respond_to do |format|
	    format.html
	    format.json {render json: @param_vals}
    end
  end

  # GET /param_vals/new
  # GET /param_vals/new.json
  def new
    @param_val = ParamVal.new

    render json: @param_val
  end

  # POST /param_vals
  # POST /param_vals.json
  def create
    @param_val = ParamVal.new(params[:param_val])

    if @param_val.save
      render json: @param_val, status: :created, location: @param_val
    else
      render json: @param_val.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /param_vals/1
  # PATCH/PUT /param_vals/1.json
  def update
    @param_val = ParamVal.find(params[:id])

    if @param_val.update_attributes(params[:param_val])
      head :no_content
    else
      render json: @param_val.errors, status: :unprocessable_entity
    end
  end

  # DELETE /param_vals/1
  # DELETE /param_vals/1.json
  def destroy
    @param_val = ParamVal.find(params[:id])
    @param_val.destroy

    head :no_content
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
  
  private
  
  def sort_column
    default_value = "updated_at"
    ParamVal.column_names.include?(params[:sort]) ? params[:sort] : default_value  
  end
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  
end
