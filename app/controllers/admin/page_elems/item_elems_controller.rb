class Admin::PageElems::ItemElemsController < ApplicationController
  layout 'admin'
  before_filter :initialize_requested_page, :check_admin


  def new
    @item_elem = ItemElem.new
    @item_elem.build_element(:element_area => params[:element_area], :display_title => true)
  end


  def edit
  end


  def create
    @item_elem = ItemElem.new(params[:item_elem])
    if @item_elem.element.dynamic_page = @requested_page.page and  @item_elem.save
      redirect_to(shortcut_path(@requested_page.shortcut), :notice => "Item Display Element successfully added!")
    else
      render :action => 'new'
    end
  end


  def update
    if @item_elem.update_attributes(params[:item_elem])
      redirect_to(shortcut_path(@requested_page.shortcut), :notice => "Item Display Element successfully updated!")
    else
      render :action => 'edit'
    end
  end

  def destroy
    @item_elem.destroy
    redirect_to(shortcut_path(@requested_page.shortcut), :notice => 'Element successfully destroyed.')
  end


  private
  def initialize_requested_page
    if params[:id]
      @item_elem = ItemElem.find(params[:id])
      @requested_page = @item_elem.element.dynamic_page.page
    end
    super
  end

end

