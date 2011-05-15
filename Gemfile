source 'http://rubygems.org'

gem 'rails',     :git => 'git://github.com/rails/rails.git'
gem 'jquery-rails'
# For Heroku...
gem 'therubyracer-heroku', '0.8.1.pre3'
gem 'ckeditor', '3.4.3.pre'
gem 'paperclip'
gem 'simple-navigation'#, :git => 'git://github.com/andi/simple-navigation.git'
gem 'devise'
gem 'acts_as_tree'#, :git => 'git://github.com/parasew/acts_as_tree.git'
gem 'carmen'
gem 'mail'#, :git => 'https://github.com/mikel/mail.git'
gem 'aws-s3'
gem 'dalli' # For memcache
gem 'kaminari'
gem 'event-calendar', :require => 'event_calendar'



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
  # Install the ruby javascript compiler, since linux doesnt come with one
  #gem "therubyracer"
  # To use debugger
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'mysql2', :git => 'git://github.com/brianmario/mysql2.git'
end

group :production do
  gem 'pg'
end
