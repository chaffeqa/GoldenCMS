class Admin::PostsController < ApplicationController
  layout 'admin'
  before_filter :check_admin
  before_filter :initialize_requested_page, :except => [:new, :create]


  def new
    @blog = Blog.find(params[:blog_id])
    @post = @blog.posts.new
    @post.build_page(:displayed => true)
  end


  def edit
  end


  def create
    @blog = Blog.find(params[:blog_id])
    @post = @blog.posts.build(params[:post])
    if @post.save and @blog.page.children << @post.page
      redirect_to( shortcut_path(@post.page.shortcut), :notice => 'Post was successfully created.')
    else
      render :action => "new"
    end
  end


  def update
    if @post.update_attributes(params[:post])
      redirect_to( shortcut_path(@requested_page.shortcut), :notice => 'Post was successfully updated.')
    else
      render :action => "edit"
    end
  end


  def destroy
    @post.destroy
    redirect_to( shortcut_path(@blog.page.shortcut), :notice => 'Post was successfully destroyed' )
  end

  private

  def initialize_requested_page
    @blog = Blog.find(params[:blog_id])
    @post = Post.find(params[:id])
    @post.build_page(:displayed => true) unless @post.page
    @requested_page = @post.page
    super
  end

end
