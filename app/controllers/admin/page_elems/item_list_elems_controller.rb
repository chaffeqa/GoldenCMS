class Admin::PageElems::ItemListElemsController < ApplicationController
  layout 'admin'
  before_filter :get_page, :check_admin


  def new
    @item_list_elem = ItemListElem.new
    @item_list_elem.build_element(:element_area => params[:element_area], :display_title => true)
  end


  def edit
  end


  def create
    @item_list_elem = ItemListElem.new(params[:item_list_elem])
    if @item_list_elem.element.dynamic_page = @page.page and  @item_list_elem.save
      redirect_to(shortcut_path(@page.shortcut), :notice => "Item List Element successfully added!")
    else
      render :action => 'new'
    end
  end


  def update
    if @item_list_elem.update_attributes(params[:item_list_elem])
      redirect_to(shortcut_path(@page.shortcut), :notice => "Item List Element successfully updated!")
    else
      render :action => 'edit'
    end
  end

  def destroy
    @item_list_elem.destroy
    redirect_to(shortcut_path(@page.shortcut), :notice => 'Element successfully destroyed.')
  end


  private
  def get_page
    if params[:id]
      @item_list_elem = ItemListElem.find(params[:id])
      @page = @item_list_elem.element.dynamic_page.page
    end
    super
  end

end

