class RoutingController < ApplicationController
  before_filter :get_node

  # Routing method for all shortcut_path routes, looks for a Node for the current
  # request and renders or redirects appropriatly.
  # Also decides whether to cache or lookup a cached html response for this request
  def by_shortcut
    inventory_search if params[:inventory_search].present?
    if @node.cachable and not admin?
      # Try to render the response from cache...
      render_with_cache(page_cache_key) { 
        render(@node.template_path_to_render, :layout => @node.layout_name) 
      }
    else
      # Render the response normally...
      render(@node.template_path_to_render, :layout => @node.layout_name)
    end
  end
  
  
  private
  
  # @Returns [String] Key this page's full html is cached under
  def page_cache_key
    'node-page::'+request.fullpath+'::'+@node.cache_key
  end
    
  # Instantiates @items 
  # @items [ActiveRecord Query] Query chain for the request's Item search
  def inventory_search    
    @items = Item.item_search(@search_params).page(@page).per(@per_page)
  end

end

