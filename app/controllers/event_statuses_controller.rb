class EventStatusesController < ApplicationController
	# GET /event_statuses
	# GET /event_statuses.json
	def index
		@event_statuses = EventStatus.all

		respond_to do |format|
			format.html
			format.json {render json: @event_statuses}
		end
	end

	# GET /event_statuses/1
	# GET /event_statuses/1.json
	def show
		@event_statuses = EventStatus.find(params[:id])

		respond_to do |format|
			format.html
			format.json {render json: @event_statuses}
		end
	end

	# GET /event_statuses/new
	# GET /event_statuses/new.json
	def new
		@event_status = EventStatus.new

		render json: @event_status
	end

	# POST /event_statuses
	# POST /event_statuses.json
	def create
		@event_status = EventStatus.new(params[:event_status])

		if @event_status.save
			render json: @event_status, status: :created, location: @event_status
		else
			render json: @event_status.errors, status: :unprocessable_entity
		end
	end

	# PATCH/PUT /event_statuses/1
	# PATCH/PUT /event_statuses/1.json
	def update
		@event_status = EventStatus.find(params[:id])

		if @event_status.update_attributes(params[:event_status])
			head :no_content
		else
			render json: @event_status.errors, status: :unprocessable_entity
		end
	end

	# DELETE /event_statuses/1
	# DELETE /event_statuses/1.json
	def destroy
		@event_status = EventStatus.find(params[:id])
		@event_status.destroy

		head :no_content
	end

	def import
		EventStatus.import(params[:file])
		redirect_to root_url
	end
end