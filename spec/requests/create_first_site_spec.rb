require 'spec_helper'

describe "When creating the first Site" do
  let(:site) {build(:site)}
  
  context 'and no Administrator account exists' do
    let(:administrator) {build(:administrator)}
    it "prompts a new admin to signup" do
      Administrator.count.should eq(0)
      visit root_path
      current_path.should == new_administrator_registration_path
      page.should have_content("No Administrator account currently exists, please create one")
    end  
    
    it "should not allow you to create a new site" do
      Administrator.count.should eq(0)
      visit root_path
      current_path.should_not == new_admin_sites_path
      visit new_admin_sites_path
      current_path.should_not == new_admin_sites_path
    end
    
    it 'allows the new admin to signup and redirects him to a new site page' do
      Administrator.count.should eq(0)
      visit new_administrator_registration_path
      current_path.should == new_administrator_registration_path
      fill_in "Email", :with => administrator.email
      fill_in "Password", :with => administrator.password
      fill_in "Password confirmation", :with => administrator.password
      click_button "Sign up"
      current_path.should == new_admin_sites_path
    end
  end  
    
  context 'and an Administrator is signed in' do
    let(:administrator) {create(:administrator)}
      
    it 'allows the new site to be created' do
      login_admin(administrator) 
      visit root_path
      current_path.should == new_admin_sites_path
      page.should have_content("No site currently exists, please create one")
    end
    
    it "allows user to create a new site" do
      login_admin(administrator)
      visit new_admin_sites_path
      fill_in "Site Name", :with => site.site_name
      fill_in "Subdomain", :with => site.subdomain
      click_button "Create Site"
      current_path.should == root_path
      page.should have_content("Site successfully created!")
    end
  end  
     

end
