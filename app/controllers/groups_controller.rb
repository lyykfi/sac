class GroupsController < ApplicationController
  helper_method :sort_column, :sort_direction
  respond_to :html, :json, :js, :xml

  def index
    params[:page] && params[:page].to_i > 0 ? params[:page] : 1

    @editable = (params[:editable] == "true")

    @groups = Group.order(sort_column + " " + sort_direction).paginate(page: params[:page])

    @groups = @groups.filtered_by(associations: [
        {name: :group, field: :position},
        {name: :group, field: :name},
        {name: :group, field: :short_name}
    ], search_condition: params[:search]) if params[:search]
    @groups = GroupDecorator.decorate_collection(@groups)
    @groups = PaginatingDecorator.new(@groups)

    respond_to do |format|
      format.html
      format.json { render json: @groups.decorated_collection }
      format.xml {render xml: @groups.decorated_collection}
      format.js
      format.csv {send_data Group.to_csv_xls(:csv), type: 'text/csv; charset=cp-1251; header=present', disposition: "attachment; filename=groups.csv"}
      format.xls {send_data Group.to_csv_xls(:xls), type: 'text/xls; charset=cp-1251; header=present', disposition: "attachment; filename=groups.xls"}
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
    error_ids = safe_destroy(params[:ids].split(','))
    error_names = Group.find(error_ids).map{|p| p.short_name}

    respond_to do |format|
      format.html
      format.js {render 'groups/destroy', locals: {error_names: error_names, error_ids: error_ids}}
    end
  end

  def import
    Group.import(params[:file])
    redirect_to root_url
  end

  def by_subject_and_year
    render json: Group.by_subject_and_year( params[:subject_id], params[:year] )
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
