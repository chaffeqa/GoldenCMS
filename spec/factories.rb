# User Factories
Factory.define :administrator do |f|
 f.sequence(:email) {|n| "admin#{n}@test.com" } 
 f.password "admintester"
end
Factory.define :user do |f|
 f.sequence(:email) { |n| "tester#{n}@test.com" }
 f.password "testuser"
end

Factory.define :site do |f|
  f.site_name "Test Site"
  f.subdomain "www"
  f.has_inventory true
end


