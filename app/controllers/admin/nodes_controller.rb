class Admin::PagesController < ApplicationController
  layout "admin"
  before_filter :check_admin

  def new
    @requested_page = Page.new
  end

  def create
    @requested_page = @site.build_page(params[:page])
    if @requested_page.save
      redirect_to admin_pages_path, notice: "Page successfully created!"
    else
      render :new
    end
  end

  def index
    @requested_pages = @site.page_tree
  end

  def show
    @requested_page = Page.find(params[:id])
  end

  def edit
    @requested_page = Page.find(params[:id])
  end

  def update
    if @requested_page.update_attributes(params[:page])
      redirect_to admin_pages_path, notice: "Page successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @requested_page = Page.find(params[:id])
    @requested_page.destroy ? flash[:notice] = "Page successfully destroyed!" : admin_request_error("There was an error in deleting the page.")
    redirect_to admin_pages_path
    
  end

end
