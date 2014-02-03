class ParamSubjectsController < ApplicationController
	# GET /param_subjects
	# GET /param_subjects.json
	def index
		@param_subjects = ParamSubject.all

		respond_to do |format|
			format.html
			format.json {render json: @param_subjects}
		end
	end

	# GET /param_subjects/1
	# GET /param_subjects/1.json
	def show
		@param_subjects = ParamSubject.find(params[:id])

		respond_to do |format|
			format.html
			format.json {render json: @param_subjects}
		end
	end

	# GET /param_subjects/new
	# GET /param_subjects/new.json
	def new
		@param_subject = ParamSubject.new

		render json: @param_subject
	end

	# POST /param_subjects
	# POST /param_subjects.json
	def create
		@param_subject = ParamSubject.new(params[:param_subject])

		if @param_subject.save
			render json: @param_subject, status: :created, location: @param_subject
		else
			render json: @param_subject.errors, status: :unprocessable_entity
		end
	end

	# PATCH/PUT /param_subjects/1
	# PATCH/PUT /param_subjects/1.json
	def update
		@param_subject = ParamSubject.find(params[:id])

		if @param_subject.update_attributes(params[:param_subject])
			head :no_content
		else
			render json: @param_subject.errors, status: :unprocessable_entity
		end
	end

	# DELETE /param_subjects/1
	# DELETE /param_subjects/1.json
	def destroy
		@param_subject = ParamSubject.find(params[:id])
		@param_subject.destroy

		head :no_content
	end

	def import
		ParamSubject.import(params[:file])
		redirect_to root_url
	end
end