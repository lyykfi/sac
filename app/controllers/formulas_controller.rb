class FormulasController < ApplicationController
	# GET /formulas
	# GET /formulas.json
	def index
		@formulas = Formula.all
		
		respond_to do |format|
      format.html
		  format.json {render json: @formulas}
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

	# GET /formulas/new
	# GET /formulas/new.json
	def new
		@formula = Formula.new

		render json: @formula
	end

	# POST /formulas
	# POST /formulas.json
	def create
		@formula = Formula.new(params[:formula])

		if @formula.save
			render json: @formula, status: :created, location: @formula
		else
			render json: @formula.errors, status: :unprocessable_entity
		end
	end

	# PATCH/PUT /formulas/1
	# PATCH/PUT /formulas/1.json
	def update
		@formula = Formula.find(params[:id])

		if @formula.update_attributes(params[:formula])
			head :no_content
		else
			render json: @formula.errors, status: :unprocessable_entity
		end
	end

	# DELETE /formulas/1
	# DELETE /formulas/1.json
	def destroy
		@formula = Formula.find(params[:id])
		@formula.destroy

		head :no_content
	end

	def import
		Formula.import(params[:file])
		redirect_to root_url
	end
end
