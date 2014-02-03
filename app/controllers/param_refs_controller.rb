class ParamRefsController < ApplicationController
	# GET /param_refs
	# GET /param_refs.json
	def index
		@param_refs = ParamRef.all

		respond_to do |format|
			format.html
			format.json {render json: @param_refs}
		end
	end

	# GET /param_refs/1
	# GET /param_refs/1.json
	def show
		@param_refs = ParamRef.find(params[:id])

		respond_to do |format|
			format.html
			format.json {render json: @param_refs}
		end
	end

	# GET /param_refs/new
	# GET /param_refs/new.json
	def new
		@param_ref = ParamRef.new

		render json: @param_ref
	end

	# POST /param_refs
	# POST /param_refs.json
	def create
		@param_ref = ParamRef.new(params[:param_ref])

		if @param_ref.save
			render json: @param_ref, status: :created, location: @param_ref
		else
			render json: @param_ref.errors, status: :unprocessable_entity
		end
	end

	# PATCH/PUT /param_refs/1
	# PATCH/PUT /param_refs/1.json
	def update
		@param_ref = ParamRef.find(params[:id])

		if @param_ref.update_attributes(params[:param_ref])
			head :no_content
		else
			render json: @param_ref.errors, status: :unprocessable_entity
		end
	end

	# DELETE /param_refs/1
	# DELETE /param_refs/1.json
	def destroy
		@param_ref = ParamRef.find(params[:id])
		@param_ref.destroy

		head :no_content
	end

	def import
		ParamRef.import(params[:file])
		redirect_to root_url
	end
end
