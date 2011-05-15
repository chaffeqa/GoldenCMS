module SiteSpecificHelper
  
  # Build the Home page for the passed in site
  def build_home_page(site)
    @home_page ||= DynamicPage.new(
        :template_name => 'home', 
        :node_attributes => {
          :title => 'Home', 
          :menu_name => 'Home',
          :shortcut => @site.home_shortcut,
          :displayed => true
    })
    @home_page.node.site = @site
    @home_page
  end
  
  # Build the basic menu tree.  Should be called after the Site and Root node are created
  def build_basic_menu_tree(site)
    root = site.node; errors = []
    # Instantiate the blogs and calendars nodes
    errors = errors + root.children.create(:menu_name => 'Blogs', :title => 'Blogs', :shortcut => site.blogs_shortcut, :displayed => false).errors.full_messages
    errors = errors + root.children.create(:menu_name => 'Calendars', :title => 'Calendars', :shortcut => site.calendars_shortcut, :displayed => false).errors.full_messages
    # Instantiate the inventory structure if this site has an inventory
    if site.has_inventory
      inventory_node = root.children.create(:menu_name => 'Inventory', :title => 'Inventory', :shortcut => site.inventory_shortcut, :displayed => true)
      errors = errors + inventory_node.errors.full_messages
      if inventory_node.valid?
        # Instantiate the items node if this site has an a specific node for Items
        (errors = errors + inventory_node.children.create(:menu_name => 'Items', :title => 'Items', :shortcut => site.items_shortcut, :displayed => true).errors.full_messages) if site.create_items_node?
        # Instantiate the categories node if this site has an a specific node for Categories
        (errors = errors + inventory_node.children.create(:menu_name => 'Categories', :title => 'Categories', :shortcut => site.categories_shortcut, :displayed => true).errors.full_messages) if site.create_categories_node?
      end
    end
    # Log any errors, and then add them to the passed in site
    unless errors.empty?
      logger.error "DB **************** Build_Basic_Menu_Tree Errors: **************** "
      errors.each {|err| site.errors.add(:base, err); logger.error "#{err}" }
      logger.error "DB **************** END Build_Basic_Menu_Tree Errors **************** "
    end
    # Return true if there were no errors
    return errors.empty?
  end
  
end
