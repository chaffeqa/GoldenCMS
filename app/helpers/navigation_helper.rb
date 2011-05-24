module NavigationHelper
  
  # Overrides the render_navigation call in order to render site specific structure and add :flat => true capability
  # as well as caching capability
  def render_navigation(options={})
    flat = options.delete(:flat) || false
    if @current_site and @current_site.node
      key = flat ? "flat-tree::#{@current_site.cache_key}" : "tree::#{@current_site.cache_key}"
      cached = Rails.cache.read(key)
      if cached
        logger.debug log_format("CACHE","Read Cache key: #{key.to_s}")
        items = cached
      else
        logger.debug log_format("CACHE","Write Cache key: #{key.to_s}")
        items = (flat ? @current_site.flat_node_tree : @current_site.node_tree)
        Rails.cache.write(key, items) if cached.nil?
      end
      return raw(super(options.merge({:items => items})))
    end
    return ""
  end
  
  def dynamic_pages_options_tree_recursive(node, addition, neglected_id='')
    array = []
    array << ["#{addition} #{h(node.menu_name)}", "#{node.id}"] unless node.id == neglected_id
    node.children.dynamic_pages.each do |childnode|
      array += dynamic_pages_options_tree_recursive(childnode, "#{addition}---", neglected_id)
    end
    array
  end

  # returns an array representing the inventory category tree.  Uses the category.node.title and category.node.id.
  # Ex. [..., ['Biblical','1'], ['...Babylon', '2'], ...]
  def cat_options_tree_recursive(node, addition)
    array = []
    array << ["#{addition} #{h(node.title)}", "#{node.id}"]
    node.children.categories.each do |childnode|
      array += cat_options_tree_recursive(childnode, "#{addition}---")
    end
    array
  end

  # returns an array representing the inventory category tree.  Uses the category.title and category.id.
  # Ex. [..., ['Biblical','1'], ['...Babylon', '2'], ...]
  def cat_id_options_tree_recursive(node, addition)
    array = []
    array << ["#{addition} #{h(node.title)}", "#{node.page_id}"] if node.page_type == 'Category'
    node.children.categories.each do |childnode|
      array += cat_id_options_tree_recursive(childnode, "#{addition}---")
    end
    array
  end

  # returns an array representing the inventory category tree.  Uses the category.title and category.title.
  # Ex. [..., ['Biblical','Biblical'], ['...Babylon', 'Babylon'], ...]
  def cat_title_options_tree_recursive(node, addition)
    array = []
    array << ["#{addition} #{h(node.title)}", "#{node.title}"] if node.page_type == 'Category'
    node.children.categories.each do |childnode|
      array += cat_title_options_tree_recursive(childnode, "#{addition}---")
    end
    array
  end

  def item_options_tree(categories)
    array = []
    categories.each do |cat|
      if cat.has_items? or cat.node.children.empty?
        array << ["#{h(cat.title)}", "#{cat.node.id}"]
      end
    end
    array
  end
  
end
