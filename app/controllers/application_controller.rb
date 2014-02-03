class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  before_filter :set_api_host

  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  protect_from_forgery

  def safe_destroy(ids)
    model = get_model(self)
    items = model.find(ids)

    error_ids = []
    items.each do |i|
      list_of_associations(:has_many).each do |a|
        if i.send(a).any?
          error_ids << i.id unless error_ids.include?(i.id)
        end
      end
      i.destroy unless error_ids.include?(i.id)
    end
    error_ids
  end

  def cors_preflight_check
    if request.method == :options
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, X-CSRF-Token'
      headers['Access-Control-Max-Age'] = '1728000'
      render :text => '', :content_type => 'text/plain'
    end
  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  # def after_sign_out_path_for(resource)
  #   root_path
  # end

  private
    def get_model(controller)
      controller.class.name.sub("Controller", "").singularize.constantize
    end

    def list_of_associations(association_type)
      get_model(self).send(:reflect_on_all_associations, association_type.to_sym).map{|x| x.name}
    end

    def set_api_host
      gon.api_host = request.protocol + request.host_with_port
    end

end
