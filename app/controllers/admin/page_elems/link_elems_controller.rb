class Admin::PageElems::LinkElemsController < ApplicationController
  layout 'admin'
  before_filter :get_page, :check_admin

  def new
    @link_elem = LinkElem.new(:link_type => 'Url')
    @link_elem.build_element(:element_area => params[:element_area], :display_title => true)
  end


  def edit
  end


  def create
    @link_elem = LinkElem.new(params[:link_elem])
    if  @link_elem.element.dynamic_page = @page.page and  @link_elem.save
      redirect_to shortcut_path(@page.shortcut), :notice => "Link Element successfully added!"
    else
      render :action => 'new'
    end
  end


  def update
    if @link_elem.update_attributes(params[:link_elem])# and @element.update_attributes(:column_order => params[:column_order], :title => params[:title], :display_title => params[:display_title], :position => params[:position])
      redirect_to shortcut_path(@page.shortcut), :notice => "Link Element successfully updated!"
    else
      render :action => 'edit'
    end
  end


  def file
    send_file "#{@link_elem.link_file.path}", :type => @link_elem.link_file_content_type # TODO get x-sendfile => true to work
  end


  def destroy
    @link_elem.destroy
    redirect_to(shortcut_path(@page.shortcut), :notice => 'Element successfully destroyed.')
  end

  private
  def get_page
    if params[:id]
      @link_elem = LinkElem.find(params[:id])
      @page = @link_elem.element.dynamic_page.page
    end
    super
  end

end

