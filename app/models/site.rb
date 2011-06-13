class Site < ActiveRecord::Base
  
  # Site#config_params is a YAML hash
  serialize :config_params

  ####################################################################
  # Associations
  ###########

  has_one :root_page, :class_name => "Page", :foreign_key => 'site_id'
  has_many :pages, :foreign_key => 'root_site_id'



  ####################################################################
  # Validations and Callbacks
  ###########

  #Validations
  #validate :ensure_site_root
  validates :site_name, :presence => true, 
                        :format => { :with => /^[a-zA-Z0-9\ -]+$/, :message => 'can only contain alphanumeric characters, spaces, and dashes.'}
  validates :subdomain, :uniqueness => true,
                        :format => { :with => /^[a-z0-9-]+$/, :message => 'can only contain lowercase alphanumeric characters and dashes.'}
  
  # TODO: this may be too strict a policy, consider removing
  #validate :ensure_site_root

  
  # Validate to ensure this application has one and only one Site object with subdomain = 'www'
  def ensure_site_root
    if Site.all.count == 0 and subdomain != "www"
      errors.add(:subdomain, "must be 'www' since this is the first site record.  Note: the 'www' sudomain will be the site used when a request asks for '' subdomain.") 
    end
  end
  
  
  
  

  ####################################################################
  # Scopes
  ###########



  ####################################################################
  # Helpers
  ###########
  
  

  # Caller for the FLAT (level 1 and 2 combined) page tree creation
  def flat_page_tree
    @flat_tree ||= ([{
        :key => "page_#{self.root_page.id}".to_sym,
        :name => self.root_page.menu_name,
        :url => self.root_page.url,
        :options => {:class => "#{self.root_page.page_type} #{self.root_page.displayed ? '' : 'not-displayed'}"},
        :items => []
    }] + self.root_page.children.collect {|page| page.tree_hash_value } )
    @flat_tree
  end

  # Caller for the page tree creation
  def page_tree
    @tree ||= [self.root_page.tree_hash_value]
    @tree
  end

  # Returns one site object after attempting to match it with a passed in subdomains.
  # @subdomains [Array:strings] Ex. ["www","GoldenCMS"]
  # Default returns the first site
  # TODO: fix so that <sitename>.heroku.com works
  def self.find_by_subdomains(subdomains)    
    # Replace [""] occurrence with ["www"]...
    subdomains << "www" unless subdomains.delete("").nil? 
    where(:subdomain => subdomains).try(:first) || order("id").first
  end
  
  # Get this site's page by the passed in shortcut. 
  # NOTE returns the root page if the shorcut is '' (to make site root requests work)
  def initialize_requested_page_by_shortcut(shortcut)
    return root_page if shortcut == ''
    pages.where(:shortcut => shortcut).try(:first)
  end
  
  # Attempts to create the basic site tree hierarchy
  def initialize_site_tree
    self.errors[:base] << 'Site Tree root already initialized!' if root_page
    return (create_home_page and create_basic_menu_tree) if errors.empty?
    return false
  end
  
  # Returns a sorted and indented site page-tree array for populating a <select> element
  def site_tree_select
    pages.order(:names_depth_cache).map { |c| ["--" * c.depth + c.menu_name, c.id] }
  end
  
  
  
  
  
  
  
  ####################################################################
  # Site specific methods
  ###########  

  # Returns an array of reserved shortcut strings
  def reserved_shortcuts
    [home_shortcut, items_shortcut, inventory_shortcut, blogs_shortcut, calendars_shortcut, categories_shortcut, items_shortcut].uniq.compact
  end
  
  # Returns all the reserved pages for this site
  def reserved_pages
    [initialize_requested_page_by_shortcut(home_shortcut), initialize_requested_page_by_shortcut(items_shortcut), initialize_requested_page_by_shortcut(inventory_shortcut), initialize_requested_page_by_shortcut(blogs_shortcut),
    initialize_requested_page_by_shortcut(calendars_shortcut), initialize_requested_page_by_shortcut(categories_shortcut), initialize_requested_page_by_shortcut(items_shortcut)].uniq.compact
  end
  
  # Returns this site's Blog shortcut
  def blogs_shortcut
    (config_params||DEFAULT_CONFIG_PARAMS)["Blogs Shortcut"]
  end

  # Returns this site's Calendar shortcut
  def calendars_shortcut
    (config_params||DEFAULT_CONFIG_PARAMS)["Calendars Shortcut"]
  end

  # Returns this site's Inventory shortcut
  def inventory_shortcut
    (config_params||DEFAULT_CONFIG_PARAMS)["Inventory Shortcut"]
  end

  # Returns this site's Categories shortcut
  def categories_shortcut
    (config_params||DEFAULT_CONFIG_PARAMS)["Categories Shortcut"]
  end

  # Returns this site's Items shortcut
  def items_shortcut
    (config_params||DEFAULT_CONFIG_PARAMS)["Items Shortcut"]
  end

  # Returns this site's Root page shortcut
  def home_shortcut
    (config_params||DEFAULT_CONFIG_PARAMS)["Home Shortcut"]
  end
  
  # True if this site should have a separate categories page
  def create_categories_page?
    categories_shortcut != inventory_shortcut
  end
  
  # True if this site should have a separate items page
  def create_items_page?
    items_shortcut != inventory_shortcut
  end  
  
  # Set the config_params to the Application defaults...
  def init_default_attributes
    self.config_params ||= DEFAULT_CONFIG_PARAMS
    self.has_inventory = true
  end
  
  
  
  
  
  private
  
  ####################################################################
  # Site Building Methods
  ###########  
  
  # Build the Home page for the passed in site
  def create_home_page
    home_page = self.build_root_page(
          :title => home_shortcut.humanize, 
          :menu_name => home_shortcut.humanize,
          :shortcut => home_shortcut,
          :layout_name => HOME_PAGE_TEMPLATE,
          :displayed => true,
          :cachable => true,
          :total_element_areas => TEMPLATES[HOME_PAGE_TEMPLATE]["total_element_areas"]
    )
    logger.debug "Home Page: #{home_page.inspect}"
    home_page.save
    self.errors[:base] << home_page.errors.full_messages.map {|msg| "Error on creating the 'Home' page: " + msg }  
    # Log any errors
    unless errors.empty?
      logger.error "*********** site.create_home_page Errors: *************"
      errors.full_messages.each {|err| logger.error "#{err}" }
      logger.error "********* End site.create_home_page Errors: ***********"
    end
    return errors.empty?
  end
  
  # Build the basic menu tree.  Should be called after the Site and Root page are created
  def create_basic_menu_tree
    # Instantiate the blogs and calendars pages
    self.errors[:base] << self.root_page.children.create(
      :menu_name => blogs_shortcut.humanize, :title => blogs_shortcut.humanize, :shortcut => blogs_shortcut, :displayed => false
    ).errors.full_messages.map {|msg| "Error on creating the 'Blogs' page: " + msg } 
    self.errors[:base] << self.root_page.children.create(
      :menu_name => calendars_shortcut.humanize, :title => calendars_shortcut.humanize, :shortcut => calendars_shortcut, :displayed => false
    ).errors.full_messages.map {|msg| "Error on creating the 'Calendars' page: " + msg } 
    # Instantiate the inventory structure if this site has an inventory
    if has_inventory
      self.errors[:base] << self.root_page.children.create(
        :menu_name => inventory_shortcut.humanize, :title => inventory_shortcut.humanize, :shortcut => inventory_shortcut, :displayed => true
      ).errors.full_messages.map {|msg| "Error on creating the 'Inventory' page: " + msg } 
      # Instantiate the items page if this site has an a specific page for Items
      self.errors[:base] << self.root_page.children.create(
        :menu_name => items_shortcut.humanize, :title => items_shortcut.humanize, :shortcut => items_shortcut, :displayed => false
      ).errors.full_messages.map {|msg| "Error on creating the 'Items' page: " + msg }  if create_items_page?
      # Instantiate the categories page if this site has an a specific page for Categories
      self.errors[:base] << self.root_page.children.create(
        :menu_name => categories_shortcut.humanize, :title => categories_shortcut.humanize, :shortcut => categories_shortcut, :displayed => false
      ).errors.full_messages.map {|msg| "Error on creating the 'Categories' page: " + msg }  if create_categories_page?
    end
    # Log any errors
    unless errors.empty?
      logger.error "*********** site.create_basic_menu_tree Errors: *************"
      errors.full_messages.each {|err| logger.error "#{err}" }
      logger.error "********* End site.create_basic_menu_tree Errors: ***********"
    end
    # Return true if there were no errors
    return errors.empty?
  end
  
  
  

end

