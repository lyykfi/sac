class ParamsController < ApplicationController
  def names_by_level
    render json: Param.names_by_level( params[:level] )
  end

  def vals_by_param_id_and_year
    render json: ParamValue.vals_by_param_id_and_year( params[:param_id], params[:year] )
  end

  def map_by_param_id_and_year
    render json: ParamValue.show_map( params[:param_id], params[:year], params[:part] )
  end
end
