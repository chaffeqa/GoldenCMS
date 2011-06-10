class Admin::PagesController < ApplicationController
  layout "admin"
  before_filter :check_admin

  def new
    @page = Page.new
  end

  def create
    @page = @site.build_page(params[:page])
    if @page.save
      redirect_to admin_pages_path, notice: "Page successfully created!"
    else
      render :new
    end
  end

  def index
    @pages = @site.page_tree
  end

  def show
    @page = Page.find(params[:id])
  end

  def edit
    @page = Page.find(params[:id])
  end

  def update
    if @page.update_attributes(params[:page])
      redirect_to admin_pages_path, notice: "Page successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy ? flash[:notice] = "Page successfully destroyed!" : admin_request_error("There was an error in deleting the page.")
    redirect_to admin_pages_path
    
  end

end
