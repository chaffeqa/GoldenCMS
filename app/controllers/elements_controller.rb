class ElementsController < ApplicationController
  before_filter :check_admin
  before_filter :get_node
  
  def destroy
    @current_element.destroy
    redirect_to( shortcut_path(@node.shortcut), :notice => 'Element successfully Destroyed')
  end

  def move_up
    @element = Element.find(params[:id])
    @element.move_higher
    redirect_to( shortcut_path(@node.shortcut), :notice => 'Element successfully Moved')
  end

  def move_down
    @element = Element.find(params[:id])
    @element.move_lower
    redirect_to( shortcut_path(@node.shortcut), :notice => 'Element successfully Moved')
  end  
  
  def new_element
    if request.post? and params[:elem_controller].present?
      respond_to do |format|
        format.html { redirect_to(:controller => "admin/page_elems/#{params[:elem_controller]}", :action => 'new', :shortcut => params[:shortcut], :page_area => params[:page_area]) }
        format.js { redirect_to(:controller => "admin/page_elems/#{params[:elem_controller]}", :action => 'new', :shortcut => params[:shortcut], :page_area => params[:page_area], :format => :js) }
      end
    else
      flash[:alert] = "Error in building a new element."
      redirect_to(:back)
    end 
  end


  private
  def get_node
    if params[:id]
      @current_element = Element.find(params[:id])
      @node = @current_element.node
    end
    super
  end

end
