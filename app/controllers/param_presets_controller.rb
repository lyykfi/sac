class ParamPresetsController < ApplicationController
  # GET /param_presets
  # GET /param_presets.json
  def index
    @param_presets = !params[:year] ? ParamPreset.all : ParamPreset.where('year == ?', params[:year])

    respond_to do |format|
	    format.html
	    format.json {render json: @param_presets}
    end
  end

  # GET /param_presets/1
  # GET /param_presets/1.json
  def show
    @param_preset = ParamPreset.find(params[:id])

    respond_to do |format|
	    format.html
	    format.json {render json: @param_preset}
    end
  end

  # GET /param_presets/new
  # GET /param_presets/new.json
  def new
    @param_preset = ParamPreset.new

    render json: @param_preset
  end

  # POST /param_presets
  # POST /param_presets.json
  def create
    @param_preset = ParamPreset.new(params[:param_preset])

    if @param_preset.save
      render json: @param_preset, status: :created, location: @param_preset
    else
      render json: @param_preset.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /param_presets/1
  # PATCH/PUT /param_presets/1.json
  def update
    @param_preset = ParamPreset.find(params[:id])

    if @param_preset.update_attributes(params[:param_preset])
      head :no_content
    else
      render json: @param_preset.errors, status: :unprocessable_entity
    end
  end

  # DELETE /param_presets/1
  # DELETE /param_presets/1.json
  def destroy
    @param_preset = ParamPreset.find(params[:id])
    @param_preset.destroy

    head :no_content
  end

  def import
	  ParamPreset.import(params[:file])
	  redirect_to root_url
  end
end
