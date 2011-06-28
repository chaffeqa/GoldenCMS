class Admin::ElementsController < ApplicationController
  before_filter :check_admin
  before_filter :initialize_requested_page

  def new
    @element = @requested_page.elements.build(:page_area => params[:page_area] || 1)
    @element_type = params[:elem_type]    
  end
  
  
  def create
    @element = Element.new(params[:element])
    if @element.save
      redirect_to(@requested_page.url, :notice => "Element successfully added!")
    else
      flash.now[:error] = 'Errors in creating Element'
      render :action => 'new'
    end
  end

  
  def destroy
    if request.post? and @current_element.destroy
      flash[:notice] = 'Element successfully Destroyed.' 
    else
      admin_request_error('Element failed to be destroyed.')
    end
    redirect_to( shortcut_path(@requested_page.shortcut))
  end

  def move_up
    if request.post? and @current_element.move_higher
      flash[:notice] = 'Element successfully Moved.' 
    else
      admin_request_error('Element failed to be Moved.')
    end    
    redirect_to( shortcut_path(@requested_page.shortcut))
  end

  def move_down
    if request.post? and @current_element.move_lower
      flash[:notice] = 'Element successfully Moved.' 
    else
      admin_request_error('Element failed to be Moved.')
    end    
    redirect_to( shortcut_path(@requested_page.shortcut))
  end  
  
  # Redirects to the appropriate Elem builder page.
  # TODO refactor to make the new element form point to the correct controller
  def new
    if params[:elem_controller].present?
      respond_to do |format|
        format.html { redirect_to(:controller => "admin/page_elems/#{params[:elem_controller]}", :action => 'new', :shortcut => @requested_page.shortcut, :element_area => params[:element_area]) }
        format.js { redirect_to(:controller => "admin/page_elems/#{params[:elem_controller]}", :action => 'new', :shortcut => @requested_page.shortcut, :element_area => params[:element_area], :format => :js) }
      end
    else
      admin_request_error("Were sorry, something Went wrong with the request.")
      redirect_to(:back)
    end 
  end


  private
  
  # Sets @requested_page object based on the params   
  def initialize_requested_page
    if params[:page_id].present?
      @requested_page = Page.find(params[:page_id])
    else
      admin_request_error("Were sorry, something went wrong with the request.")
      redirect_to(:back)
      return false
    end      
    @current_element = Element.find(params[:id])  if params[:id].present?
    super
  end

end
