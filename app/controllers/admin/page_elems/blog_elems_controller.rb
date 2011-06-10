class Admin::PageElems::BlogElemsController < ApplicationController
  layout 'admin'
  before_filter :get_page, :check_admin


  def new
    @blog_elem = BlogElem.new
    @blog_elem.build_element(:element_area => params[:element_area], :display_title => true)
  end


  def edit
  end


  def create
    @blog_elem = BlogElem.new(params[:blog_elem])
    if @blog_elem.element.dynamic_page = @page.page and  @blog_elem.save
      redirect_to(shortcut_path(@page.shortcut), :notice => "Blog Element successfully added!")
    else
      render :action => 'new'
    end
  end


  def update
    params[:blog_elem][:blog_ids] ||= []
    if @blog_elem.update_attributes(params[:blog_elem])
      redirect_to(shortcut_path(@page.shortcut), :notice => "Blog Element successfully updated!")
    else
      render :action => 'edit'
    end
  end

  def destroy
    @blog_elem.destroy
    redirect_to(shortcut_path(@page.shortcut), :notice => 'Element successfully destroyed.')
  end


  private
  def get_page
    @available_blogs = Blog.all
    if params[:id]
      @blog_elem = BlogElem.find(params[:id])
      @page = @blog_elem.element.dynamic_page.page
    end
    super
  end

end

