class Admin::EventsController < ApplicationController
  layout 'admin'
  before_filter :check_admin
  before_filter :initialize_requested_page, :except => [:new, :create]


  def new
    @calendar = Calendar.find(params[:calendar_id])
    @event = @calendar.events.new
    @event.build_page(:displayed => true)
  end


  def edit
  end


  def create
    @calendar = Calendar.find(params[:calendar_id])
    @event = @calendar.events.build(params[:event])
    if @event.save and @calendar.page.children << @event.page
      redirect_to( shortcut_path(@event.page.shortcut), :notice => 'Event was successfully created.')
    else
      render :action => "new"
    end
  end


  def update
    if @event.update_attributes(params[:event])
      redirect_to( shortcut_path(@requested_page.shortcut), :notice => 'Event was successfully updated.')
    else
      render :action => "edit"
    end
  end


  def destroy
    @event.destroy
    redirect_to( shortcut_path(@calendar.page.shortcut), :notice => 'Event was successfully destroyed' )
  end

  private

  def initialize_requested_page
    @calendar = Calendar.find(params[:calendar_id])
    @event = Event.find(params[:id])
    @event.build_page(:displayed => true) unless @event.page
    @requested_page = @event.page
    super
  end
end
