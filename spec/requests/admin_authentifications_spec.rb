require 'spec_helper'

describe "AdminRegistrations" do

  describe "GET /administrators/sign_up" do

    it "redirects if no admin is signed in" do
      pending "TODO"
    end
    
    it "allows you to sign up a new admin" do
      pending "TODO"
    end
    
    it "leaves the current admin signed in after signing up a new admin" do
      pending "TODO"
    end

  end
end


describe "AdminAuthentifications" do
  
  describe "GET /administrators/sign_in" do
  
    it "displays the sign in page" do
      pending "TODO"
    end
        
    it 'allows an administrator to sign in' do
      pending "TODO"
    end
  end
  
  describe 'GET /administrators/sign_out' do
   
    it 'logs the current administrator out' do
      pending "TODO"
    end
  end
end
