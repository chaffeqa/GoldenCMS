class InventoryController < ApplicationController
  before_filter :get_page

  def inventory
    render_with_cache
  end

  def search
    @items = Item.item_search(@search_params).page(@page).per(@per_page)
  end



  private

  def get_page
    @page = @current_site.get_page_by_shortcut(@current_site.inventory_shortcut) if request.parameters['action'] == 'inventory'
    @page = @current_site.get_page_by_shortcut(@current_site.items_shortcut)  if request.parameters['action'] == 'search'
    super
  end
end

