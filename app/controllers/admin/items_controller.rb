class Admin::ItemsController < ApplicationController
  layout 'admin'
  before_filter :check_admin
  
  def index
    @items = Item.admin_item_filters(@search_params).page(@page).per(@per_page)
  end


  def new
    @item = Item.new
    @item.build_node(:displayed => true)
  end

  def edit
    @item = Item.find(params[:id])
    @item.build_node(:displayed => true) unless @item.node
  end

  def create
    #build_dynamic_type TODO for additional association params
    @item = Item.new(params[:item])
    if @item.save
      redirect_to(admin_items_url(), :notice => 'Item was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(params[:item])
      redirect_to(shortcut_path(@item.node.shortcut), :notice => 'Item was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to(admin_items_url(), :notice => 'Item was successfully destroyed.' )
  end
  
  

  private

  def build_dynamic_type
    params[:item].delete(:adjustable_dimension_attributes) unless params[:item][:dimension_type] == 'Adjustable'
    params[:item].delete(:circular_dimension_attributes) unless params[:item][:dimension_type] == 'Circular'
    params[:item].delete(:cube_dimension_attributes) unless params[:item][:dimension_type] == 'Cube'
    params[:item].delete(:drum_dimension_attributes) unless params[:item][:dimension_type] == 'Drum'
    params[:item].delete(:flexible_dimension_attributes) unless params[:item][:dimension_type] == 'Flexible'
    params[:item].delete(:funnel_dimension_attributes) unless params[:item][:dimension_type] == 'Funnel'
    params[:item].delete(:pool_dimension_attributes) unless params[:item][:dimension_type] == 'Pool'
    params[:item].delete(:sorbent_dimension_attributes) unless params[:item][:dimension_type] == 'Sorbent'
    params[:item].delete(:standard_dimension_attributes) unless params[:item][:dimension_type] == 'Standard'

    puts params[:item].keys
  end

end
