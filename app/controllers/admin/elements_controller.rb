class Admin::ElementsController < ApplicationController
  before_filter :check_admin
  before_filter :get_node
  
  def destroy
    if request.post? and @current_element.destroy
      flash[:notice] = 'Element successfully Destroyed.' 
    else
      admin_request_error('Element failed to be destroyed.')
    end
    redirect_to( shortcut_path(@node.shortcut))
  end

  def move_up
    if request.post? and @current_element.move_higher
      flash[:notice] = 'Element successfully Moved.' 
    else
      admin_request_error('Element failed to be Moved.')
    end    
    redirect_to( shortcut_path(@node.shortcut))
  end

  def move_down
    if request.post? and @current_element.move_lower
      flash[:notice] = 'Element successfully Moved.' 
    else
      admin_request_error('Element failed to be Moved.')
    end    
    redirect_to( shortcut_path(@node.shortcut))
  end  
  
  def new_element
    if request.post? and params[:elem_controller].present?
      respond_to do |format|
        format.html { redirect_to(:controller => "admin/page_elems/#{params[:elem_controller]}", :action => 'new', :shortcut => params[:shortcut], :page_area => params[:page_area]) }
        format.js { redirect_to(:controller => "admin/page_elems/#{params[:elem_controller]}", :action => 'new', :shortcut => params[:shortcut], :page_area => params[:page_area], :format => :js) }
      end
    else
      admin_request_error("Were sorry, something Went wrong with the request.")
      redirect_to(:back)
    end 
  end


  private
  def get_node
    if params[:id].present?
      @current_element = Element.find(params[:id])
      @node = @current_element.node
    end
    super
  end

end
