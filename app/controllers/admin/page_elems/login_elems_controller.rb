class Admin::PageElems::LoginElemsController < ApplicationController
  layout 'admin'
  before_filter :initialize_requested_page, :check_admin


  def new
    @element = Element.new(:element_area => params[:element_area], :display_title => true, :elem_type => 'LoginElem', :title => 'Authentication')
    if @element.dynamic_page = @requested_page.page and @element.save
      redirect_to(shortcut_path(@requested_page.shortcut), :notice => "Login Element successfully added!")
    else
      redirect_to(shortcut_path(@requested_page.shortcut), :alert => "Login Element failsed to be added!")
    end
  end


  def edit
  end


  def create
    @blog_elem = BlogElem.new(params[:blog_elem])
    if @blog_elem.save and  @requested_page.page.elements << @blog_elem.element
      redirect_to(shortcut_path(@requested_page.shortcut), :notice => "Blog Element successfully added!")
    else
      render :action => 'new'
    end
  end


  def update
    if @blog_elem.update_attributes(params[:blog_elem])
      redirect_to(shortcut_path(@requested_page.shortcut), :notice => "Blog Element successfully updated!")
    else
      render :action => 'edit'
    end
  end

  def destroy
    @blog_elem.destroy
    redirect_to(shortcut_path(@requested_page.shortcut), :notice => 'Element successfully destroyed.')
  end


  private
  def initialize_requested_page
    if params[:id]
      @blog_elem = BlogElem.find(params[:id])
      @requested_page = @blog_elem.element.dynamic_page.page
    end
    super
  end

end

