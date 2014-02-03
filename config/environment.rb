# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
SacMiddle::Application.initialize!

SacMiddle::Application.configure do
  config.map_root_path = if Rails.env.production?
    ENV['HOME'] + '/sac_static/' + 'images/map/'
  else
    root.to_s + '_static/' + 'images/map/'
  end
  config.color_map_root_path = config.map_root_path + 'colored/'
  config.color_map_cache_path = config.color_map_root_path + 'cache/'
  config.color_map_cache_url = "/static/#{config.color_map_cache_path.split('/')[-4..-1].join('/')}/"
end