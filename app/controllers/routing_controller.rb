class RoutingController < ApplicationController
  before_filter :get_node

  # Routing method for all shortcut_path routes, looks for a Node for the current
  # request and renders or redirects appropriatly
  def by_shortcut
    inventory_search if params[:inventory_search].present?
    if params[:fresh].present? or admin?
      render(@node.template_path_to_render, :layout => @node.layout)
    else
      render_with_cache('node-page::'+request.fullpath+'::'+@node.cache_key) { render(@node.template_path_to_render, :layout => @node.layout) }
    end
  end
  
  
  private
  
  def inventory_search    
    @items = Item.item_search(@search_params).page(@page).per(@per_page)
  end

end

