source 'http://rubygems.org'

gem 'rails', '3.1.0.rc5'#:git => 'git://github.com/rails/rails.git'
gem 'jquery-rails'
# Install the ruby javascript compiler, since linux doesnt come with one
gem 'therubyracer-heroku', '0.8.1.pre3'
gem 'ckeditor', '3.5.3'
gem 'paperclip'
gem 'simple-navigation'
gem 'devise'
gem 'carmen'
gem 'mail'
gem 'ancestry'
gem 'acts_as_list'
gem 'aws-s3'
gem 'dalli' # For memcache
gem 'kaminari'
gem 'event-calendar', :require => 'event_calendar'
gem 'to_slug'

# Asset template engines
gem 'uglifier'
gem 'sass'
gem 'coffee-script'



########################
# Environment Specific #
########################

group :test, :development do
  gem "rspec-rails"
  gem 'mysql2', :git => 'git://github.com/brianmario/mysql2.git'
  gem 'rake', '~>0.9.2'
end

group :test do
  gem "factory_girl_rails"
  gem "capybara"
  gem "guard-rspec"
  # For Gaurd Linux support...
  gem 'rb-inotify'
  gem 'libnotify'
  # Pretty printed test output...
  gem 'turn'#, :require => false
  gem 'database_cleaner'
end

group :development do
  gem 'heroku'
  gem 'rails-footnotes', '>= 3.7'
end

group :production do
  gem 'pg'
end

