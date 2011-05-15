class Admin::PageElems::ImageElemsController < ApplicationController
  layout 'admin'
  before_filter :get_node, :check_admin

  def new
    @image_elem = ImageElem.new
    @image_elem.build_element(:page_area => params[:page_area], :display_title => true)
  end


  def edit
  end


  def create
    @image_elem = ImageElem.new(params[:image_elem])
    if @image_elem.element.dynamic_page = @node.page and  @image_elem.save
      if params[:new_image].blank?
        redirect_to shortcut_path(@node.shortcut), :notice => "Image Element successfully added!"
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
        redirect_to shortcut_path(@node.shortcut), :notice => "Image Element successfully updated!"
      else
        render :action => 'edit'
      end
    else
      render :action => 'edit'
    end
  end


  def destroy
    @image_elem.destroy
    redirect_to(shortcut_path(@node.shortcut), :notice => 'Element successfully destroyed.')
  end

  private
  def get_node
    if params[:id]
      @image_elem = ImageElem.find(params[:id])
      @node = @image_elem.element.dynamic_page.node
    end
    super
  end
end

