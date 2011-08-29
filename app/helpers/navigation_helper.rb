module NavigationHelper
  
  # Overrides the render_navigation call in order to render site specific structure and add :flat => true capability
  # as well as caching capability
  def render_navigation(options={})
    flat = options.delete(:flat) || false
    if @requested_site and @requested_site.page
      key = flat ? "flat-tree::#{@requested_site.cache_key}" : "tree::#{@requested_site.cache_key}"
      cached = Rails.cache.read(key)
      if cached
        logger.debug log_format("CACHE","Read Cache key: #{key.to_s}")
        items = cached
      else
        logger.debug log_format("CACHE","Write Cache key: #{key.to_s}")
        items = (flat ? @requested_site.flat_page_tree : @requested_site.page_tree)
        Rails.cache.write(key, items) if cached.nil?
      end
      return raw(super(options.merge({:items => items})))
    end
    return ""
  end
  
  
  def multi_level_navigation_html(ancestors)
    page = ancestors.pop
    content_tag(:ul) do 
      page.children_nav_pages.each do |child_page| 
        content_tag_for(:li, child_page) do 
          link_to child_page.menu_name, child_page.url, :class => ("selected" if ancestors.empty?)
          (+ multi_level_navigation_html(ancestors) ) if not ancestors.empty? and child_page == ancestors.last 
        end
      end
    end
  end
  
  
  
  def item_options_tree(categories)
    array = []
    categories.each do |cat|
      if cat.has_items? or cat.page.children.empty?
        array << ["#{h(cat.title)}", "#{cat.page.id}"]
      end
    end
    array
  end
  
end
