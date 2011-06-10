class Admin::PageElems::TextElemsController < ApplicationController
  layout 'admin'
  before_filter :initialize_requested_page, :check_admin


  def new
    @text_elem = TextElem.new
    @text_elem.build_element(:element_area => params[:element_area], :display_title => true)
  end


  def edit
  end


  def create
    @text_elem = TextElem.new(params[:text_elem])
    if @text_elem.element.dynamic_page = @requested_page.page and @text_elem.save
      redirect_to(shortcut_path(@requested_page.shortcut), :notice => "Text Element successfully added!")
    else
      flash.now[:error] = 'Errors'
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
    @text_elem.destroy
    redirect_to(shortcut_path(@requested_page.shortcut), :notice => 'Element successfully destroyed.')
  end



  private
  def initialize_requested_page
    if params[:id]
      @text_elem = TextElem.find(params[:id])
      @requested_page = @text_elem.element.dynamic_page.page
    end
    super
  end


end

