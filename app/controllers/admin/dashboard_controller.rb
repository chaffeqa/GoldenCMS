class Admin::DashboardController < ApplicationController
  layout 'admin'
  before_filter :check_admin
  
  def index
    
  end
end
