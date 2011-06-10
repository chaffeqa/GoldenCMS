class Admin::BlogsController < ApplicationController
  layout 'admin'
  before_filter :check_admin
  before_filter :initialize_requested_page, :except => [:new, :create, :index]

  def index
    @blogs = Blog.page(@requested_page).per(@per_page)
    @blogs = @blogs.order(@sort + " " + @direction) unless @sort.blank?
  end


  def new
    @blog = Blog.new
    @blog.build_page(:displayed => true)
  end


  def edit
  end


  def create
    @blog = Blog.new(params[:blog])
    if @blog.save
      redirect_to( shortcut_path(@blog.page.shortcut), :notice => 'Blog was successfully created.')
    else
      render :action => "new"
    end
  end


  def update
    if @blog.update_attributes(params[:blog])
      redirect_to( shortcut_path(@blog.page.shortcut), :notice => 'Blog was successfully updated.')
    else
      render :action => "edit"
    end
  end


  def destroy
    @blog.destroy
    redirect_to( admin_blogs_url, :notice => 'Blog was successfully destroyed.' )
  end

  private

  def initialize_requested_page
    @blog = Blog.find(params[:id])
    @blog.build_page(:displayed => true) unless @blog.page
    @requested_page = @blog.page
    super
  end

end
