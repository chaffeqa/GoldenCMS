class Admin::SitesController < ApplicationController
  include SiteSpecificHelper
  layout 'admin'
  before_filter :check_admin
  skip_filter :get_site
  
  def index
    @sites = Site.all
  end

  def new
    @site = Site.new
    @site.init_default_attributes
  end

  def create
    @site = Site.new(params[:site])
    @site.build_home_page
    @site.build_basic_menu_tree
    # Instantiate the site, root node, root page, and all base nodes for the site
    if @site.save
      redirect_to root_url, :notice => 'Site successfully created!'
    else
      if @site.new_record?
        logger.warn "Error in site instantiation: @site = #{@site.inspect}"
        render :new
      else 
        logger.warn "Error in site heirarchy creation: @site = #{@site.inspect}, @home_page = #{@site.node.inspect}"
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

