class Site < ActiveRecord::Base
  
  # Site#config_params is a YAML hash
  serialize :config_params

  ####################################################################
  # Associations
  ###########

  has_one :node
  has_many :nodes, :foreign_key => 'site_scoped_id'



  ####################################################################
  # Validations and Callbacks
  ###########

  #Validations
  #validate :ensure_site_root
  validates :site_name, :presence => true, 
                        :format => { :with => /^[a-zA-Z0-9-]+$/, :message => 'can only contain alphanumeric characters and dashes.'}
  validates :subdomain, :uniqueness => true,
                        :format => { :with => /^[a-z0-9-]+$/, :message => 'can only contain lowercase alphanumeric characters and dashes.', :allow_blank => true}
  

  
  # Validate to ensure this application has one and only one Site object with subdomain = ''
  def ensure_site_root
    if subdomain.blank?
      # Test if another site already has a subdomain = ''
      errors.add(:subdomain, "is already taken.") if self.class.where(:subdomain => '').where("sites.id != ?", id || 0).count > 0
    else
      # Test if no other site has a subdomain = '', in which case we want this site subdomain = ''
      errors.add(:subdomain, "must be blank since this is the first site record.") if self.class.where(:subdomain => '').where("sites.id != ?", id || 0).empty?
    end
  end
  
  
  
  

  ####################################################################
  # Scopes
  ###########



  ####################################################################
  # Helpers
  ###########
  
  

  # Caller for the FLAT (level 1 and 2 combined) node tree creation
  def flat_node_tree
    @flat_tree ||= ([{
        :key => "node_#{self.node.id}".to_sym,
        :name => self.node.menu_name,
        :url => self.node.url,
        :options => {:class => "#{self.node.page_type} #{self.node.displayed ? '' : 'not-displayed'}"},
        :items => []
    }] + self.node.children.collect {|node| node.tree_hash_value } )
    @flat_tree
  end

  # Caller for the node tree creation
  def node_tree
    @tree ||= [self.node.tree_hash_value]
    @tree
  end

  # Returns the site
  def self.get_subdomain(subdomain="")
    where(:subdomain => subdomain).try(:first)
  end
  
  # Get this site's node by the passed in shortcut
  def get_node_by_shortcut(shortcut="")
    nodes.where(:shortcut => shortcut).try(:first)
  end
  
  
  
  
  
  
  
  ####################################################################
  # Site specific methods
  ###########  

  # Returns an array of reserved shortcut strings
  def reserved_shortcuts
    [home_shortcut, items_shortcut, inventory_shortcut, blogs_shortcut, calendars_shortcut, categories_shortcut, items_shortcut].uniq.compact
  end
  
  # Returns all the reserved nodes for this site
  def reserved_nodes
    [get_node_by_shortcut(home_shortcut), get_node_by_shortcut(items_shortcut), get_node_by_shortcut(inventory_shortcut), get_node_by_shortcut(blogs_shortcut),
    get_node_by_shortcut(calendars_shortcut), get_node_by_shortcut(categories_shortcut), get_node_by_shortcut(items_shortcut)].uniq.compact
  end
  
  # Returns this site's Blog shortcut
  def blogs_shortcut
    config_params["blogs_shortcut"]
  end

  # Returns this site's Calendar shortcut
  def calendars_shortcut
    config_params["calendars_shortcut"]
  end

  # Returns this site's Inventory shortcut
  def inventory_shortcut
    config_params["inventory_shortcut"]
  end

  # Returns this site's Categories shortcut
  def categories_shortcut
    config_params["categories_shortcut"]
  end

  # Returns this site's Items shortcut
  def items_shortcut
    config_params["items_shortcut"]
  end

  # Returns this site's Root node shortcut
  def home_shortcut
    config_params["home_shortcut"]
  end
  
  # True if this site should have a separate categories node
  def create_categories_node?
    categories_shortcut != inventory_shortcut
  end
  
  # True if this site should have a separate items node
  def create_items_node?
    items_shortcut != inventory_shortcut
  end
  
  
  ####################################################################
  # Site Building Methods
  ###########  
  
  
  # Set the config_params to the Application defaults...
  def init_default_attributes
    self.config_params ||= DEFAULT_CONFIG_PARAMS
    self.has_inventory = true
  end
  
  # Build the Home page for the passed in site
  def build_home_page
    home_node = self.build_node(
          :title => home_shortcut.humanize, 
          :menu_name => home_shortcut.humanize,
          :shortcut => home_shortcut,
          :layout_name => HOME_PAGE_TEMPLATE,
          :displayed => true
    )
    home_page = DynamicPage.new
    home_page.node = home_node
    home_page
  end
  
  # Build the basic menu tree.  Should be called after the Site and Root node are created
  def build_basic_menu_tree
    # Instantiate the blogs and calendars nodes
    self.node.children.build(:menu_name => blogs_shortcut.humanize, :title => blogs_shortcut.humanize, :shortcut => blogs_shortcut, :displayed => false)
    self.node.children.build(:menu_name => calendars_shortcut.humanize, :title => calendars_shortcut.humanize, :shortcut => calendars_shortcut, :displayed => false)
    # Instantiate the inventory structure if this site has an inventory
    if has_inventory
      inventory_node = self.node.children.build(:menu_name => inventory_shortcut.humanize, :title => inventory_shortcut.humanize, :shortcut => inventory_shortcut, :displayed => true)
      if inventory_node.valid?
        # Instantiate the items node if this site has an a specific node for Items
        inventory_node.children.build(:menu_name => items_shortcut.humanize, :title => items_shortcut.humanize, :shortcut => items_shortcut, :displayed => true)
        # Instantiate the categories node if this site has an a specific node for Categories
        inventory_node.children.build(:menu_name => categories_shortcut.humanize, :title => categories_shortcut.humanize, :shortcut => categories_shortcut, :displayed => true)
      end
    end
    # Log any errors, and then add them to the passed in site
    unless errors.empty?
      logger.error "Build_Basic_Menu_Tree Errors:"
      errors.full_messages.each {|err| logger.error "#{err}" }
    end
    # Return true if there were no errors
    return errors.empty?
  end
  

end

