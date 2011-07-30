module RequestMacros 

  # Logs in an Admin
  def login_admin(administrator)
    #post_via_redirect administrator_session_path, 'administrator[email]' => administrator.email, 'administrator[password]' => administrator.password
    visit new_administrator_session_path
    fill_in "Email", :with => administrator.email
    fill_in "Password", :with => administrator.password
    click_button "Sign in"
  end
  
  # Destroys all admin accounts
  def clear_administrator_accounts
    Administrator.destroy_all
  end

  # Runs a simple test to determine if the admin bar is visible  
  def admin_should_be_logged_in
    page.should have_content('adminBar')
  end
end
