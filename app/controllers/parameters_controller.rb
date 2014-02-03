class ParametersController < ApplicationController
  # GET /parameters
  # GET /parameters.json
  def index
    @parameters = Parameter.all

    respond_to do |format|
	    format.html
	    format.json {render json: @parameters}
    end
  end

  # GET /parameters/1
  # GET /parameters/1.json
  def show
    @parameter = Parameter.find(params[:id])

    respond_to do |format|
	    format.html
	    format.json {render json: @parameters}
    end
  end

  # GET /parameters/new
  # GET /parameters/new.json
  def new
    @parameter = Parameter.new

    render json: @parameter
  end

  # POST /parameters
  # POST /parameters.json
  def create
    @parameter = Parameter.new(params[:parameter])

    if @parameter.save
      render json: @parameter, status: :created, location: @parameter
    else
      render json: @parameter.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /parameters/1
  # PATCH/PUT /parameters/1.json
  def update
    @parameter = Parameter.find(params[:id])

    if @parameter.update_attributes(params[:parameter])
      head :no_content
    else
      render json: @parameter.errors, status: :unprocessable_entity
    end
  end

  # DELETE /parameters/1
  # DELETE /parameters/1.json
  def destroy
    @parameter = Parameter.find(params[:id])
    @parameter.destroy

    head :no_content
  end

  def import
	  Parameter.import(params[:file])
	  redirect_to root_url
  end
end
