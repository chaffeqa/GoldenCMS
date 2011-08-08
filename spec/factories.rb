#Factory.defineGirl.define do
  # Administrator Factories
  Factory.define :administrator do |f|
    f.sequence(:email) {|n| "admin#{n}@test.com" } 
    f.password "admintester"
  end

  # Site Factories

  Factory.define :site do |f|
    f.site_name "Test Site"
    f.subdomain "www"
    f.has_inventory true
  end

  # Page Factories

  Factory.define :page do |f|
    f.sequence(:title) {|n| "Page #{n}"}
    f.sequence(:menu_name) {|n| "Page #{n}"}
    f.sequence(:shortcut) {|n| "page-#{n}"}
    f.layout_name "inside"
    f.total_element_areas 2
  end 

  # Element Factoreis

  Factory.define :element do |f|
    f.title "Test Element"
    f.element_area 1
    f.association :page
  end
#end
