source 'http://rubygems.org'

gem 'rails', '3.1.0.rc6'
gem 'jquery-rails'
gem "ckeditor", "~> 3.6.0"
gem 'paperclip'
gem 'devise'
gem 'mail'
gem 'ancestry'
gem 'acts_as_list'
gem 'will_paginate', '~> 3.0'
gem 'to_slug'
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
	gem 'mysql2', :git => 'git://github.com/brianmario/mysql2.git'
	gem 'rake', '~>0.9.2'
	gem 'therubyracer', '>= 0.9.2'
	gem 'rspec'
	gem 'rspec-rails'
	gem "autotest"
	gem 'web-app-theme'
	gem 'hpricot'
	gem 'ruby_parser'
	gem 'rails3-generators' #mainly for factory_girl & simple_form at this point
	gem "factory_girl_rails", "~> 1.1"
	gem 'cucumber-rails'
end

group :test do
	# database_cleaner is not required, but highly recommended
	gem 'database_cleaner'
	gem 'capybara'
  gem 'turn'
end

# To use gems:

#gem 'aws-s3'
#gem 'dalli' # For memcache
#gem "carrierwave"
#gem "mini_magick"
