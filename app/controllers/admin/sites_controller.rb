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
  end

  def create
    @site = Site.new(params[:site])
    # Instantiate the site, root node, root page, and all base nodes for the site
    if build_home_page(@site).save and @site.save and build_basic_menu_tree(@site) and @site.node.save # Hotfix to make the root node capture the site_id
      redirect_to root_url, :notice => 'Site successfully created!'
    else
      if @site.new_record?
        logger.warn "Error in site instantiation: @site = #{@site.inspect}"
        render :new
      else 
        logger.warn "Error in site heirarchy creation: @site = #{@site.inspect}, @home_page = #{@home_page.inspect}"
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

