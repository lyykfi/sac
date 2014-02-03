source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '3.2.12'
gem 'jquery-rails', '2.2.1'
gem 'jquery-ui-rails', "~> 4.0.2"
gem "will_paginate", "~> 3.0.4"

gem "capistrano", "~> 2.14.2"
gem "unicorn", "~> 4.6.2"
gem "simple_form", "~> 2.1.0"

gem "devise", "~> 2.2.3"
gem "cancan", "~> 1.6.9"
gem 'draper', '~> 1.0'
gem 'coffee-rails', '3.2.2'
gem 'uglifier', '1.3.0'
gem 'slim-rails', '1.1.0'

group :assets do
  gem 'sass-rails', '~> 3.2'
  gem 'bootstrap-sass', '~> 2.3.1.0'
  gem 'therubyracer', '0.11.4'
  gem 'font-awesome-sass-rails', '3.0.2.2'
	gem 'roo', '1.10.3'
end

group :development do
	gem 'better_errors'
	gem 'binding_of_caller'
	gem 'meta_request'
end

group :development, :test do
	gem 'sqlite3', '1.3.7'
	gem 'rspec-rails', '2.13.0'
end

group :test do
	gem 'capybara', '2.0.2'
	gem 'cucumber-rails'
	gem 'database_cleaner'
end

group :production do

end

group :development, :production do
	gem 'mysql2', '0.3.11'
end

gem 'best_in_place'