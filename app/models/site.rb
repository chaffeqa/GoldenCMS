class Site < ActiveRecord::Base

  ####################################################################
  # Associations
  ###########

  belongs_to :node






  ####################################################################
  # Validations and Callbacks
  ###########

  #Validations
  validate :ensure_site_root
  validates :site_name, :presence => true
  validates :subdomain, :uniqueness => true,
                        :format => { :with => /^[a-z0-9-]+$/, :message => 'can only contain lowercase alphanumeric characters and dashes.', :allow_blank => true}

  

  def ensure_site_root
    unless subdomain.blank?
      errors.add(:subdomain, "must be blank since this is the first site record") if Site.where(:subdomain => '').where("sites.id != ?", id || 0).empty?
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
    where(:subdomain => subdomain).first || self.first
  end
  
  # Get this site's node by the passed in shortcut
  def get_node_by_shortcut(shortcut="")
    nodes.where(:shortcut => shortcut).first
  end
  
  # Get this site's nodes
  def nodes
    Node.where(:site_id => id)
  end
  
  
  
  
  
  
  
  ####################################################################
  # Site specific methods
  ###########

  # Returns an array of reserved shortcut strings
  def reserved_shortcuts
    RESERVED_SHORTCUTS.values
  end
  
  # Returns all the reserved nodes for this site
  def reserved_nodes
    [get_node_by_shortcut(home_shortcut), get_node_by_shortcut(items_shortcut), get_node_by_shortcut(inventory_shortcut), get_node_by_shortcut(blogs_shortcut),
    get_node_by_shortcut(calendars_shortcut), get_node_by_shortcut(categories_shortcut), get_node_by_shortcut(items_shortcut)].uniq.compact
  end
  
  # Returns this site's Blog shortcut
  def blogs_shortcut
    RESERVED_SHORTCUTS[:blogs]
  end

  # Returns this site's Calendar shortcut
  def calendars_shortcut
    RESERVED_SHORTCUTS[:calendars]
  end

  # Returns this site's Inventory shortcut
  def inventory_shortcut
    RESERVED_SHORTCUTS[:inventory]
  end

  # Returns this site's Categories shortcut
  def categories_shortcut
    RESERVED_SHORTCUTS[:categories]
  end

  # Returns this site's Items shortcut
  def items_shortcut
    RESERVED_SHORTCUTS[:items]
  end

  # Returns this site's Root node shortcut
  def home_shortcut
    RESERVED_SHORTCUTS[:home]
  end
  
  # True if this site should have a separate categories node
  def create_categories_node?
    categories_shortcut != inventory_shortcut
  end
  
  # True if this site should have a separate items node
  def create_items_node?
    items_shortcut != inventory_shortcut
  end
  

end

