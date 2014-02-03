class UomsController < ApplicationController
  # GET /uoms
  # GET /uoms.json
  def index
    @uoms = Uom.all

    respond_to do |format|
	    format.html
	    format.json {render json: @uoms}
    end
  end

  # GET /uoms/1
  # GET /uoms/1.json
  def show
    @uom = Uom.find(params[:id])

    respond_to do |format|
	    format.html
	    format.json {render json: @uom}
    end
  end

  # GET /uoms/new
  # GET /uoms/new.json
  def new
    @uom = Uom.new

    render json: @uom
  end

  # POST /uoms
  # POST /uoms.json
  def create
    @uom = Uom.new(params[:uom])

    if @uom.save
      render json: @uom, status: :created, location: @uom
    else
      render json: @uom.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /uoms/1
  # PATCH/PUT /uoms/1.json
  def update
    @uom = Uom.find(params[:id])

    if @uom.update_attributes(params[:uom])
      head :no_content
    else
      render json: @uom.errors, status: :unprocessable_entity
    end
  end

  # DELETE /uoms/1
  # DELETE /uoms/1.json
  def destroy
    @uom = Uom.find(params[:id])
    @uom.destroy

    head :no_content
  end

  def import
	  Uom.import(params[:file])
	  redirect_to root_url
  end
end
