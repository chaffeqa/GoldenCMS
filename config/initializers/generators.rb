GoldenCMS::Application.config.generators do |g|
  g.test_framework :rspec, :views => false, :fixture => true
  g.fixture_replacement :factory_girl, :dir => 'spec/factories'
end
# Add the lib directory to the load path
GoldenCMS::Application.config do |c|
  c.autoload_paths += %W(#{config.root}/lib)
  c.autoload_paths += Dir["#{config.root}/lib/**/"]
end