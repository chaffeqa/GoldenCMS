class Admin::DynamicPagesController < ApplicationController
  layout 'admin'
  before_filter :check_admin
  before_filter :get_page, :only => [ :edit, :update, :destroy]

  def index
    @dynamic_pages = DynamicPage.page(@page).per(@per_page)
    @dynamic_pages = @dynamic_pages.order(@sort + " " + @direction) unless @sort.blank?
  end


  def new
    @dynamic_page = DynamicPage.new
    @dynamic_page.build_node(:displayed => true)
  end


  def edit
    @dynamic_page.build_node(:displayed => true) unless @dynamic_page.node
  end


  def create
    @dynamic_page = DynamicPage.new(params[:dynamic_page])
    # Set current_site root to this pages node unless it is already set
    @dynamic_page.node.site = @current_site unless @current_site.node
    if @dynamic_page.save
      redirect_to( admin_dynamic_pages_path(), :notice => 'Page was successfully created.')
    else
      render :action => "new"
    end
  end


  def update
    if @dynamic_page.update_attributes(params[:dynamic_page])
      redirect_to( admin_dynamic_pages_path(), :notice => 'Page was successfully updated.')
    else
      render :action => "edit"
    end
  end


  def destroy
    @dynamic_page.destroy
    redirect_to( admin_dynamic_pages_url, :notice => 'Page was successfully destroyed.'  )
  end

  
private
  
  def get_page
    @dynamic_page = DynamicPage.find(params[:id])
  end
end
