class Admin::BlogsController < ApplicationController
  layout 'admin'
  before_filter :check_admin
  before_filter :get_node, :except => [:new, :create, :index]

  def index
    @blogs = Blog.page(@page).per(@per_page)
    @blogs = @blogs.order(@sort + " " + @direction) unless @sort.blank?
  end


  def new
    @blog = Blog.new
    @blog.build_node(:displayed => true)
  end


  def edit
  end


  def create
    @blog = Blog.new(params[:blog])
    if @blog.save
      redirect_to( shortcut_path(@blog.node.shortcut), :notice => 'Blog was successfully created.')
    else
      render :action => "new"
    end
  end


  def update
    if @blog.update_attributes(params[:blog])
      redirect_to( shortcut_path(@blog.node.shortcut), :notice => 'Blog was successfully updated.')
    else
      render :action => "edit"
    end
  end


  def destroy
    @blog.destroy
    redirect_to( admin_blogs_url, :notice => 'Blog was successfully destroyed.' )
  end

  private

  def get_node
    @blog = Blog.find(params[:id])
    @blog.build_node(:displayed => true) unless @blog.node
    @node = @blog.node
    super
  end

end
