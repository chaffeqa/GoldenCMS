class Admin::PageElems::SideNavElemsController < ApplicationController
  layout 'admin'
  before_filter :initialize_requested_page, :check_admin


  def new
    @element=Element.new(:title => @requested_page.menu_name, :element_area => params[:element_area], :display_title => true, :elem_type => 'side_nav_elems')
    @element.dynamic_page = @requested_page.page
    if @element.save
      redirect_to(shortcut_path(@requested_page.shortcut), :notice => "Side Nav Element successfully added!")
    else
      logger.debug "Error on SideNavElems creation: element: #{@element.inspect} errors: #{@element.errors.full_messages}"
      redirect_to(shortcut_path(@requested_page.shortcut), :error => "Side Nav Element failed to be added!")
    end
  end


  def edit
  end


  def create
    @text_elem = TextElem.new(params[:text_elem])
    if @text_elem.element.dynamic_page = @requested_page.page and @text_elem.save
      redirect_to(shortcut_path(@requested_page.shortcut), :notice => "Text Element successfully added!")
    else
      render :action => 'new'
    end
  end


  def update
    if @text_elem.update_attributes(params[:text_elem])
      redirect_to(shortcut_path(@requested_page.shortcut), :notice => "Text Element successfully updated!")
    else
      render :action => 'edit'
    end
  end

  def destroy
    @element.destroy
    redirect_to(shortcut_path(@requested_page.shortcut), :notice => 'Element successfully destroyed.')
  end



  private
  def initialize_requested_page
    if params[:id]
      @element = Element.find(params[:id])
      @requested_page = @lement.dynamic_page.page
    end
    super
  end


end

