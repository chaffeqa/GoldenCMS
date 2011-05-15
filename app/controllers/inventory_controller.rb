class InventoryController < ApplicationController
  before_filter :get_node

  def inventory
    render_with_cache
  end

  def search
    @items = Item.item_search(@search_params).page(@page).per(@per_page)
  end



  private

  def get_node
    @node = @current_site.get_node_by_shortcut(@current_site.inventory_shortcut) if request.parameters['action'] == 'inventory'
    @node = @current_site.get_node_by_shortcut(@current_site.items_shortcut)  if request.parameters['action'] == 'search'
    super
  end
end

