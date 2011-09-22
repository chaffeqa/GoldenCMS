source 'http://rubygems.org'

gem 'rails', '~> 3.1.0'
gem 'jquery-rails'
gem "ckeditor", "~> 3.6.0"
gem 'paperclip'
gem 'devise'
gem 'ancestry'
gem 'acts_as_list'
gem 'will_paginate', '~> 3.0'
gem 'to_slug', require: 'to_slug'
gem "event-calendar", "~> 2.3.3", :require => 'event_calendar'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0.rc"
  gem 'coffee-rails', "~> 3.1.0.rc"
  gem 'uglifier'
end


########################
# Environment Specific #
########################

group :development, :test do
	gem 'heroku'
  gem 'taps'
	gem 'mysql2'
	gem 'rake', '~>0.9.2'
	gem 'rspec'
	gem 'rspec-rails'
	gem 'hpricot'
	gem 'ruby_parser'
	gem 'rails3-generators' #mainly for factory_girl & simple_form at this point
	gem "factory_girl_rails"
	gem 'cucumber-rails'
	gem 'shoulda'
	group :autotest do
	  gem 'autotest-rails'
  	gem "autotest"
	end
end

group :test do
	# database_cleaner is not required, but highly recommended
	gem 'launchy'
	gem 'database_cleaner'
	gem 'capybara'
  gem 'turn'
end

# To use gems:

#gem 'aws-s3'
#gem 'dalli' # For memcache
#gem "carrierwave"
#gem "mini_magick"
#gem 'therubyracer', '>= 0.9.2'
#gem 'web-app-theme'
