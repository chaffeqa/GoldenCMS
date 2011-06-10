class Admin::MenusController < ApplicationController
  layout 'admin'
  before_filter :check_admin

  def index
  end

  def sort
    if request.post?
      @errors = Page.order_tree(params['_json'])
      flash.now[:notice] = 'Menu hierarchy successfully updated' unless @errors.any?
      flash.now[:error] = "Errors on your menu update for --- #{@errors.collect {|n| n.menu_name + ': (' + n.errors.full_messages.join(', ') + ')'}.join(' --- ') }---" if @errors.any?
    else
      @errors = []
      flash.now[:error] = 'Request denied'
    end
    respond_to do |format|
      format.json { render :nothing => true }
      format.html { render :nothing => true }
    end
  end


end

