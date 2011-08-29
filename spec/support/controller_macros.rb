module ControllerMacros

  #################
  # Devise Macros #
  #################
  
  
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:administrators]
      sign_in FactoryGirl(:administrator)
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl(:user) 
      #@user.confirm! # or set a confirmed_at inside the FactoryGirl. Only necessary if you are using the confirmable module
      sign_in @user
    end
  end
  
end
