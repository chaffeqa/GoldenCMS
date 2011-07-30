require 'spec_helper'

describe "When registering an Administrator" do
  before(:all) do
    DatabaseCleaner.start
    instantiate_site
  end
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  context "and no administrator is signed in" do

    it "renders an error page" do
      admin_should_not_be_logged_in
      visit root_path
      visit new_administrator_registration_path
      page.should have_content("Maybe you tried to change something you didn't have access to")
    end    
  end
  
  context 'and an administrator is signed in' do
    let(:admin_two) {Factory.stub(:administrator)}
    
    it "allows you to sign up a new admin" do
      login_admin(@first_admin)
      admin_should_be_logged_in
      visit new_administrator_session_path
      current_path.should == new_administrator_session_path
    end
    
    it "leaves the current admin signed in after signing up a new admin" do
      login_admin(@first_admin)
      visit new_administrator_registration_path
      admin_should_be_logged_in
      fill_in "Email", :with => admin_two.email
      fill_in "Password", :with => admin_two.password
      fill_in "Password confirmation", :with => admin_two.password
      click_button "Sign up"
      page.should have_content(@first_admin.email)
      page.should have_content("Administrator (#{admin_two.email}) successfully signed up")      
    end
  end
end


describe "When athenticating an Administrator" do
  before(:all) do
    DatabaseCleaner.start
    instantiate_site
  end
  after(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end
  
  
  describe "and he is signing in" do
  
    it "displays the sign in page" do
      visit new_administrator_session_path
      admin_should_not_be_logged_in
      current_path.should == new_administrator_session_path
    end
        
    it 'allows him to sign in' do
      visit new_administrator_session_path
      admin_should_not_be_logged_in
      fill_in "Email", :with => @first_admin.email
      fill_in "Password", :with => @first_admin.password
      click_button "Sign in"
      page.should have_content("Administrator (#{@first_admin.email}) successfully signed in")
    end
  end
  
  describe 'and he is signing out' do
   
    it 'logs the current administrator out' do
      login_admin(@first_admin)
      admin_should_be_logged_in
      click_link "Log Out"
      admin_should_not_be_logged_in
    end
  end
end
