class SubjectsController < ApplicationController
  # before_filter :set_header#, :only => [:index]

  def index
    @subjects = Subject.all
    # gon.rabl 'app/views/subjects/index.json.rabl', as: :subjects
  end

  # GET /subjects/1
  # GET /subjects/1.json
  def show
    @subject = Subject.find(params[:id])

    respond_to do |format|
      format.html
      format.json {render json: @subject}
    end
  end

  # GET /subjects/new
  # GET /subjects/new.json
  def new
    @subject = Subject.new

    render json: @subject
  end

  # POST /subjects
  # POST /subjects.json
  def create
    @subject = Subject.new(params[:subject])

    if @subject.save
      render json: @subject, status: :created, location: @subject
    else
      render json: @subject.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /subjects/1
  # PATCH/PUT /subjects/1.json
  def update
    @subject = Subject.find(params[:id])

    if @subject.update_attributes(params[:subject])
      head :no_content
    else
      render json: @subject.errors, status: :unprocessable_entity
    end
  end

  # DELETE /subjects/1
  # DELETE /subjects/1.json
  def destroy
    @subject = Subject.find(params[:id])
    @subject.destroy

    head :no_content
  end

  def parent
    subject = Subject.find(params[:id])
    unless subject.parent.blank?
      @parent = subject.parent
    else
      render json: {}
    end
    # if !subject.is_country?
    #   # render json: subject.parent
    # else
    #   render json: []
    # end
  end

  def children
    @children = Subject.find(params[:id]).children
    # gon.rabl 'app/views/subjects/children.json.rabl', as: :children
    # render json: Subject.find(params[:id]).children
  end

  def subtree
    render json: Subject.find(params[:id]).subtree
  end

  def countries
    render json: Subject.countries
  end

  def districts
    @subjects = Subject.districts
    # render json: Subject.districts
  end

  def regions
    render json: Subject.regions
  end

  def import
    Subject.import(params[:file])
    redirect_to root_url
  end

  def show_map
    render json: Subject.show_color_map(params[:id_parameter], params[:id], params[:year])
  end

  # def set_header
  #   response.headers['Access-Control-Allow-Origin'] = '*'
  # end
end
