module SiteSpecificHelper
  
  # Build the Home page for the passed in site
  def build_home_page(site)
    @home_page ||= DynamicPage.new(
        :template_name => 'home', 
        :page_attributes => {
          :title => 'Home', 
          :menu_name => 'Home',
          :shortcut => @site.home_shortcut,
          :displayed => true
    })
    @home_page.page.site = @site
    @home_page
  end
  
  # Build the basic menu tree.  Should be called after the Site and Root page are created
  def build_basic_menu_tree(site)
    root = site.page; errors = []
    # Instantiate the blogs and calendars pages
    errors = errors + root.children.create(:menu_name => 'Blogs', :title => 'Blogs', :shortcut => site.blogs_shortcut, :displayed => false).errors.full_messages
    errors = errors + root.children.create(:menu_name => 'Calendars', :title => 'Calendars', :shortcut => site.calendars_shortcut, :displayed => false).errors.full_messages
    # Instantiate the inventory structure if this site has an inventory
    if site.has_inventory
      inventory_page = root.children.create(:menu_name => 'Inventory', :title => 'Inventory', :shortcut => site.inventory_shortcut, :displayed => true)
      errors = errors + inventory_page.errors.full_messages
      if inventory_page.valid?
        # Instantiate the items page if this site has an a specific page for Items
        (errors = errors + inventory_page.children.create(:menu_name => 'Items', :title => 'Items', :shortcut => site.items_shortcut, :displayed => true).errors.full_messages) if site.create_items_page?
        # Instantiate the categories page if this site has an a specific page for Categories
        (errors = errors + inventory_page.children.create(:menu_name => 'Categories', :title => 'Categories', :shortcut => site.categories_shortcut, :displayed => true).errors.full_messages) if site.create_categories_page?
      end
    end
    # Log any errors, and then add them to the passed in site
    unless errors.empty?
      logger.error log_format("DB","Build_Basic_Menu_Tree Errors: " + 
        errors.each {|err| site.errors.add(:base, err); logger.error "#{err}" })
    end
    # Return true if there were no errors
    return errors.empty?
  end
  
end
