class ParamLevelsController < ApplicationController
  # GET /param_levels
  # GET /param_levels.json
  def index
    @param_levels = ParamLevel.all

    respond_to do |format|
	    format.html
	    format.json {render json: @param_levels}
    end
  end

  # GET /param_levels/1
  # GET /param_levels/1.json
  def show
    @param_level = ParamLevel.find(params[:id])

    respond_to do |format|
	    format.html
	    format.json {render json: @param_level}
    end
  end

  # GET /param_levels/new
  # GET /param_levels/new.json
  def new
    @param_level = ParamLevel.new

    render json: @param_level
  end

  # POST /param_levels
  # POST /param_levels.json
  def create
    @param_level = ParamLevel.new(params[:param_level])

    if @param_level.save
      render json: @param_level, status: :created, location: @param_level
    else
      render json: @param_level.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /param_levels/1
  # PATCH/PUT /param_levels/1.json
  def update
    @param_level = ParamLevel.find(params[:id])

    if @param_level.update_attributes(params[:param_level])
      head :no_content
    else
      render json: @param_level.errors, status: :unprocessable_entity
    end
  end

  # DELETE /param_levels/1
  # DELETE /param_levels/1.json
  def destroy
    @param_level = ParamLevel.find(params[:id])
    @param_level.destroy

    head :no_content
  end

  def import
	  ParamLevel.import(params[:file])
	  redirect_to root_url
  end
end
