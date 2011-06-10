class Admin::PageElems::CalendarElemsController < ApplicationController
  layout 'admin'
  before_filter :initialize_requested_page, :check_admin


  def new
    @calendar_elem = CalendarElem.new
    @calendar_elem.build_element(:element_area => params[:element_area], :display_title => true)
  end


  def edit
  end


  def create
    @calendar_elem = CalendarElem.new(params[:calendar_elem])
    if @calendar_elem.element.dynamic_page = @requested_page.page and  @calendar_elem.save
      redirect_to(shortcut_path(@requested_page.shortcut), :notice => "Calendar Element successfully added!")
    else
      render :action => 'new'
    end
  end


  def update
    if @calendar_elem.update_attributes(params[:calendar_elem])
      redirect_to(shortcut_path(@requested_page.shortcut), :notice => "Calendar Element successfully updated!")
    else
      render :action => 'edit'
    end
  end

  def destroy
    @calendar_elem.destroy
    redirect_to(shortcut_path(@requested_page.shortcut), :notice => 'Element successfully destroyed.')
  end


  private
  def initialize_requested_page
    if params[:id]
      @calendar_elem = CalendarElem.find(params[:id])
      @requested_page = @calendar_elem.element.dynamic_page.page
    end
    super
  end

end

