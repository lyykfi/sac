class SubjectsController < ApplicationController
  # GET /subjects
  # GET /subjects.json
  def index
    @subjects = Subject.all

    respond_to do |format|
	    format.html
	    format.json {render json: @subjects}
    end
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
		if !subject.is_country?
	    render json: subject.parent
		else
			render json: []
		end
  end

  def children
	  render json: Subject.find(params[:id]).children
  end

  def subtree
	  render json: Subject.find(params[:id]).subtree
  end

  def countries
	  render json: Subject.countries
  end

  def districts
	  render json: Subject.districts
  end

  def regions
	  render json: Subject.regions
  end

  def import
	  Subject.import(params[:file])
	  redirect_to root_url
  end
end
