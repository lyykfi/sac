class EventsController < ApplicationController
	# GET /events
	# GET /events.json
	def index
		@events = Event.all

		respond_to do |format|
			format.html
			format.json {render json: @events}
		end
	end

	# GET /events/1
	# GET /events/1.json
	def show
		@events = Event.find(params[:id])

		respond_to do |format|
			format.html
			format.json {render json: @events}
		end
	end

	# GET /events/new
	# GET /events/new.json
	def new
		@event = Event.new

		render json: @event
	end

	# POST /events
	# POST /events.json
	def create
		@event = Event.new(params[:event])

		if @event.save
			render json: @event, status: :created, location: @event
		else
			render json: @event.errors, status: :unprocessable_entity
		end
	end

	# PATCH/PUT /events/1
	# PATCH/PUT /events/1.json
	def update
		@event = Event.find(params[:id])

		if @event.update_attributes(params[:event])
			head :no_content
		else
			render json: @event.errors, status: :unprocessable_entity
		end
	end

	# DELETE /events/1
	# DELETE /events/1.json
	def destroy
		@event = Event.find(params[:id])
		@event.destroy

		head :no_content
	end

	def import
		Event.import(params[:file])
		redirect_to root_url
	end
end