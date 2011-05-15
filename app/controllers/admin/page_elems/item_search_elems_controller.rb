class Admin::PageElems::ItemSearchElemsController < ApplicationController
  layout 'admin'
  before_filter :get_node, :check_admin


  def new
    @element=Element.new(:page_area => params[:page_area], :title => 'Browse Inventory', :display_title => true, :elem_type => 'item_search_elems')
    if @element.dynamic_page = @node.page and @element.save
      redirect_to(shortcut_path(@node.shortcut), :notice => "Side Nav Element successfully added!")
    else
      redirect_to(shortcut_path(@node.shortcut), :error => "Side Nav Element failed to be added!")
    end
  end


  def edit
  end


  def create
    @text_elem = TextElem.new(params[:text_elem])
    if @text_elem.element.dynamic_page = @node.page and  @text_elem.save
      redirect_to(shortcut_path(@node.shortcut), :notice => "Text Element successfully added!")
    else
      render :action => 'new'
    end
  end


  def update
    if @text_elem.update_attributes(params[:text_elem])
      redirect_to(shortcut_path(@node.shortcut), :notice => "Text Element successfully updated!")
    else
      render :action => 'edit'
    end
  end

  def destroy
    @text_elem.destroy
    redirect_to(shortcut_path(@node.shortcut), :notice => 'Element successfully destroyed.')
  end



  private
  def get_node
    if params[:id]
      @text_elem = TextElem.find(params[:id])
      @node = @text_elem.element.dynamic_page.node
    end
    super
  end


end

