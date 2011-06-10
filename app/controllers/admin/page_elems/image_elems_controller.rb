class Admin::PageElems::ImageElemsController < ApplicationController
  layout 'admin'
  before_filter :get_page, :check_admin

  def new
    @image_elem = ImageElem.new
    @image_elem.build_element(:element_area => params[:element_area], :display_title => true)
  end


  def edit
  end


  def create
    @image_elem = ImageElem.new(params[:image_elem])
    if @image_elem.element.dynamic_page = @page.page and  @image_elem.save
      if params[:new_image].blank?
        redirect_to shortcut_path(@page.shortcut), :notice => "Image Element successfully added!"
      else
        render :action => 'edit'
      end
    else
      render :action => 'new'
    end
  end


  def update
    if @image_elem.update_attributes(params[:image_elem])
      if params[:new_image].blank?
        redirect_to shortcut_path(@page.shortcut), :notice => "Image Element successfully updated!"
      else
        render :action => 'edit'
      end
    else
      render :action => 'edit'
    end
  end


  def destroy
    @image_elem.destroy
    redirect_to(shortcut_path(@page.shortcut), :notice => 'Element successfully destroyed.')
  end

  private
  def get_page
    if params[:id]
      @image_elem = ImageElem.find(params[:id])
      @page = @image_elem.element.dynamic_page.page
    end
    super
  end
end

