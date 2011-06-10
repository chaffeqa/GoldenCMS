source 'http://rubygems.org'

gem 'rails',     :git => 'git://github.com/rails/rails.git'
gem 'rake', '~>0.9.2'
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





group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'mysql2', :git => 'git://github.com/brianmario/mysql2.git'
end

group :development do
  gem 'heroku'
  # NOTE: debugger not working with rails --pre currently
#  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'mysql2', :git => 'git://github.com/brianmario/mysql2.git'
end

group :production do
  gem 'pg'
end

#Removed Gems:
#gem 'acts_as_tree', :git => 'git://github.com/erdah/acts_as_tree.git'
