class Admin::CalendarsController < ApplicationController
  layout 'admin'
  before_filter :check_admin
  before_filter :get_page, :except => [:new, :create, :index]

  def index
    @calendars = Calendar.page(@page).per(@per_page)
    @calendars = @calendars.order(@sort + " " + @direction) unless @sort.blank?
  end


  def new
    @calendar = Calendar.new
    @calendar.build_page(:displayed => true)
  end


  def edit
  end


  def create
    @calendar = Calendar.new(params[:calendar])
    if @calendar.save
      redirect_to( shortcut_path(@calendar.page.shortcut), :notice => 'Calendar was successfully created.')
    else
      render :action => "new"
    end
  end


  def update
    if @calendar.update_attributes(params[:calendar])
      redirect_to( shortcut_path(@calendar.page.shortcut), :notice => 'Calendar was successfully updated.')
    else
      render :action => "edit"
    end
  end


  def destroy
    @calendar.destroy
    redirect_to( admin_calendars_url, :notice => 'Calendar was successfully destroyed.'  )
  end

  private

  def get_page
    @calendar = Calendar.find(params[:id])
    @calendar.build_page(:displayed => true) unless @calendar.page
    @page = @calendar.page
    super
  end

end
