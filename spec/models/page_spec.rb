require 'spec_helper'

describe Page do
  let(:site) {Factory(:site)}
  let(:root_page) {Factory(:page, :site => site)}
  let(:child_page) {Factory(:page, :parent => root_page)}
  
  context 'basic attribute validations' do
    it 'creates a valid record' do
      Factory.build(:page).should be_valid
      Factory(:page)
    end
    it 'requires a shortcut' do
      Factory.build(:page, :shortcut => nil).should have_at_least(1).errors_on(:shortcut)
      Factory.build(:page, :shortcut => '').should have_at_least(1).errors_on(:shortcut)
    end
    it 'requires a title' do
      Factory.build(:page, :title => nil).should have_at_least(1).errors_on(:title)
      Factory.build(:page, :title => '').should have_at_least(1).errors_on(:title)
    end
    it 'requires a menu_name' do
      Factory.build(:page, :menu_name => '').should have_at_least(1).errors_on(:menu_name)
    end
    it 'requires shortcut to be slug-safe' do
      Factory.build(:page, :shortcut => 'bad/url').should have_at_least(1).errors_on(:shortcut)
      Factory.build(:page, :shortcut => 'bad url').should have_at_least(1).errors_on(:shortcut)
    end
    it 'requires a layout_name' do
      Factory.build(:page, :layout_name => '').should have_at_least(1).errors_on(:layout_name)
    end
    it 'requires a numeric total_element_areas' do
      Factory.build(:page, :total_element_areas => '').should have_at_least(1).errors_on(:total_element_areas)
    end    
  end
  
  
  context '#site' do
      
    it 'can be null' do
      Factory.build(:page).should have(0).errors_on(:site_id)
    end
    it 'corrisponds to Site.root_page' do
      root_page.should be_valid
      site.root_page == root_page
      root_page.site == site.root_page
    end
  end
  
  context '#root_site' do
    it 'can be null' do
      Factory.build(:page).should have(0).errors_on(:root_site_id)
    end
    it 'is set when its page tree has a root Site' do
      child_page; root_page; site # Invokes let statements
      child_page.root_site.should == site
    end
  end
  
  context 'shortcut uniqueness' do
    it 'requires unique shortcuts in scope of the page tree' do
      test_page = Factory.build(:page, :root_site => site, :parent => root_page, :shortcut => child_page.shortcut)
      test_page.should have_at_least(1).errors_on(:shortcut)
      test_page.shortcut = 'good-shortcut'
      test_page.should be_valid
    end
    it 'allows duplicate shortcuts when out of page tree scope' do
      test_page = Factory.build(:page, :shortcut => child_page.shortcut)
      test_page.should have(0).errors_on(:shortcut)
    end
  end
  
  context 'manipulating page hierarchy depth' do
    #TODO
  end
  
  context 'manipulating page hierarchy width' do
    #TODO
  end
end
