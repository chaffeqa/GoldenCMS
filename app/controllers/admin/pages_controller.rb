class Admin::PagesController < ApplicationController
  layout 'admin'
  before_filter :check_admin
  before_filter :initialize_page, :only => [ :edit, :update, :destroy]

  def index
    @pages = @requested_site.page_tree
  end


  def new
    @page = @requested_site.pages.build(:displayed => true)
  end
  
  def show
    format.json { @page.to_json }
  end


  def edit
  end


  def create
    @page = @requested_site.pages.build(params[:page])
    # Set current_site root to this pages page unless it is already set
    @page.site = @requested_site unless @requested_site.root_page
    if @page.save
      redirect_to( admin_pages_path(), :notice => 'Page was successfully created.')
    else
      render :action => "new"
    end
  end


  def update
    if @page.update_attributes(params[:page])
      redirect_to( admin_pages_path(), :notice => 'Page was successfully updated.')
    else
      render :action => "edit"
    end
  end



  def destroy
    @page = Page.find(params[:id])
    @page.destroy ? flash[:notice] = "Page successfully destroyed!" : admin_request_error("There was an error in deleting the page.")
    redirect_to admin_pages_path
  end

  

  def sort
    if request.post?
      @errors = Page.order_tree(params['_json'])
      flash.now[:notice] = 'Menu hierarchy successfully updated' unless @errors.any?
      flash.now[:error] = "Errors on your menu update for --- #{@errors.collect {|n| n.menu_name + ': (' + n.errors.full_messages.join(', ') + ')'}.join(' --- ') }---" if @errors.any?
    end
    respond_to do |format|
      format.json { render :nothing => true }
      format.html { render :nothing => true }
    end
  end

  
private
  
  def initialize_page
    @page = Page.find(params[:id]) if params[:id]
  end
end
