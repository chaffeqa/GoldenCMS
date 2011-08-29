FactoryGirl.define do
  # Administrator Factories
  factory :administrator do |f|
    f.sequence(:email) {|n| "admin#{n}@test.com" } 
    f.password "admintester"
  end

  # Site Factories

  factory :site do |f|
    f.site_name "Test Site"
    f.subdomain "www"
    f.has_inventory true
  end

  # Page Factories

  factory :page do |f|
    f.sequence(:title) {|n| "Page #{n}"}
    f.sequence(:menu_name) {|n| "Page #{n}"}
    f.sequence(:shortcut) {|n| "page-#{n}"}
    f.layout_name "inside"
    f.total_element_areas 2
  end 

  # Element Factoreis

  factory :element do |f|
    f.title "Test Element"
    f.element_area 1
    f.association :page
  end
end
