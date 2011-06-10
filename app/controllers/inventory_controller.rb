class InventoryController < ApplicationController
  before_filter :initialize_requested_page

  def inventory
    render_with_cache
  end

  def search
    @items = Item.item_search(@search_params).page(@requested_page).per(@per_page)
  end



  private

  def initialize_requested_page
    @requested_page = @requested_site.initialize_requested_page_by_shortcut(@requested_site.inventory_shortcut) if request.parameters['action'] == 'inventory'
    @requested_page = @requested_site.initialize_requested_page_by_shortcut(@requested_site.items_shortcut)  if request.parameters['action'] == 'search'
    super
  end
end

