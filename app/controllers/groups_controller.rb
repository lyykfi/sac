class GroupsController < ApplicationController
	helper_method :sort_column, :sort_direction
	respond_to :html, :json, :js, :xml

  def index
	  params[:page] && params[:page].to_i > 0 ? params[:page] : 1
	  @editable = params[:editable] == "true"

	  @groups = GroupDecorator.decorate_collection(Group.order(sort_column + " " + sort_direction).paginate(page: params[:page]))
	  @groups =  PaginatingDecorator.new(@groups)

	  respond_to do |format|
	    format.html
	    format.json {render json: @groups, only: [:id, :name, :short_name, :position]}
	    format.js
    end
  end

  def show
    @group = Group.find(params[:id])

    respond_to do |format|
	    format.html
	    format.json {render json: @group, only: [:id, :name, :short_name, :position]}
    end

  end

  def new
    @group = Group.new

    respond_to do |format|
	    format.html
	    format.js
    end
  end

  def create
    @group = Group.new(params[:group])
    @group.save

		respond_to do |format|
			format.js
		end
  end

  def update
    @group = Group.find(params[:id])

		@group.update_attributes(params[:group])
		respond_with @group
  end

  def destroy
		groups = Group.find_all_by_id(params[:ids].split(','))

		groups.each { |g| g.destroy }

		respond_to do |format|
			format.html
			format.js
		end
	end

	def import
		Group.import(params[:file])
		redirect_to root_url
	end

  private

	  def sort_column
		  default_value = "created_at"
		  Group.column_names.include?(params[:sort]) ? params[:sort] : default_value
	  end

	  def sort_direction
		  %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
	  end
end
