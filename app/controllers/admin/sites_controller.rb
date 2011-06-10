class Admin::SitesController < ApplicationController
  include SiteSpecificHelper
  layout 'admin'
  before_filter :check_admin
  skip_filter :initialize_requested_site
  
  def index
    @sites = Site.all
  end

  def new
    @site = Site.new
    @site.init_default_attributes
  end

  def create
    @site = Site.new(params[:site])
    # Instantiate the site, root page, root page, and all base pages for the site
    if @site.save and @site.initialize_site_tree
      redirect_to root_url, :notice => 'Site successfully created!'
    else
      if @site.new_record?
        logger.warn log_format("DB", "Error in site instantiation: @site = #{@site.inspect}")
        render :new
      else 
        logger.warn log_format("DB", "Error in site heirarchy creation: @site = #{@site.inspect}, @home_page = #{@site.page.inspect}")
        render :edit
      end
    end
  end

  def edit
    @site = Site.find(params[:id])
  end

  def update
    @site = Site.find(params[:id])
    if @site.update_attributes(params[:site])
      redirect_to edit_admin_site_path, :notice => 'Site successfully updated!'
    else
      render :edit
    end
  end

end

