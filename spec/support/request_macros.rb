module RequestMacros 


  # Creates a default administrator and site
  def instantiate_site
    @first_admin = Factory(:administrator) 
    @site = Factory.stub(:site)
    login_admin(@first_admin)
    visit new_admin_sites_path
    fill_in "Site Name", :with => @site.site_name
    fill_in "Subdomain", :with => @site.subdomain
    click_button "Create Site"
    logout_admin
  end

  # Logs in an Admin
  def login_admin(administrator)
    visit new_administrator_session_path
    fill_in "Email", :with => administrator.email
    fill_in "Password", :with => administrator.password
    click_button "Sign in"
  end
  
  # Logs out the logged in Administrator
  def logout_admin
    visit destroy_administrator_session_path
  end
  
  # Destroys all admin accounts
  def clear_administrator_accounts
    Administrator.destroy_all
  end

  # Runs a simple test to determine if the admin bar is visible  
  def admin_should_be_logged_in
    page.should have_content('Log Out')
  end
  
  # Runs a simple test to determine if the admin bar is visible  
  def admin_should_not_be_logged_in
    page.should_not have_content('Log Out')
  end
  
end
