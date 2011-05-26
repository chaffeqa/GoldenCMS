class Node < ActiveRecord::Base
  
  
  ####################################################################
  # Associations
  ###########
  belongs_to :site
  belongs_to :site_scope, :class_name => 'Site'
  has_ancestry :cache_depth => true, :orphan_strategy => :rootify  
  has_many   :link_elems, :dependent => :destroy
  has_many :elements
  
  # Creates associations for each accepted node page type
  NODE_PAGE_TYPES.keys.each do |page_type|
    has_one page_type.to_sym
    accepts_nested_attributes_for page_type.to_sym
    has_many page_type.pluralize.to_sym, :through => :children, :source => page_type.to_sym
  end



  ####################################################################
  # Validations and Callbacks
  ###########

  #Validations
  validates :shortcut, :presence => {:allow_blank => true}, :uniqueness => {:scope => :site_scope_id, :allow_blank => true}
  validates :title, :presence => true
  validates :menu_name, :presence => true
  validates :layout_name, :inclusion => { :in => TEMPLATES.keys }  
  validates :positions, :presence => true, :numericality => true
  validate :shortcut_html_safe?
  validate :reserved_node_violation?, :on => :update
  #validate :check_unique_shortcut?

  #Callbacks
  before_validation :fill_missing_fields
  before_save :set_ancestry_path_and_site_scope
  #after_save :update_cache_chain
  #before_destroy :update_cache_chain
  
  # Global method to trigger caching updates for all objects that rely on this object's information
  # This will be called in one of two cases:
  #   1) This object has changed, and effected cached objects need to recache
  #   2) An object has notified this object that it needs to recache 
  # Clears the cache items of Node calls
  def update_cache_chain
    unless self.marked_for_destruction?
      logger.debug "DB ********** Touching Node #{title} ********** "
      self.touch
    end
    if parent
      logger.debug "DB ********** Touching Node #{parent.title} ********** "
      self.parent.touch
    end
    if root and root.site
      logger.debug "DB ********** Touching Site #{root.site.subdomain} ********** "
      self.root.site.touch if self.root.site
    end
    self.link_elems.each {|elem| elem.try(:update_cache_chain) }
  end

  # Tests to see if the node changes violate the basic structural rules
  def hierarchy_structure_violation?
    # Validation if this node has no parent and is not the root node
    errors.add(:parent_id, "This page must be part of the site menu hierarchy") if parent_id.blank? and site.blank?
  end

  # Tests to see if the node changes violate the reserved node rules
  def reserved_node_violation?
    this_nodes_site = self.root.try(:site)
    # Validation if this is a reserved node being updated...
    if this_nodes_site and this_nodes_site.reserved_nodes.collect {|n| n.id}.include?(self.id)
      errors.add(:base, "You cannot adjust reserved menu page shortcuts.  Reserved menu items include: #{this_nodes_site.reserved_shortcuts.join(', ')}") unless this_nodes_site.reserved_shortcuts.include?(self.shortcut)
    end
    # Validation if this Home node
    #errors.add(:parent_id, "This page must be the root of the menu hierarchy") if self.site and !parent_id.blank?
  end

  # Checks the database to ensure the Shortcut is not already taken
  def check_unique_shortcut?
    if (not new_record? and Node.where('nodes.shortcut = ? AND nodes.id != ?', shortcut, id).exists?) or (new_record? and Node.where(:shortcut => shortcut).exists?)
      logger.warn "DB ********** Node Shortcut collision: (Title: #{title}, ID: #{id} URL: #{shortcut}), new_record: #{new_record?} ********** "
      addition = Node.where(:shortcut => shortcut).count
      suggested_shortcut = addition.to_s  + "-" + shortcut
      errors.add(:shortcut, "URL shortcut already exists in this site.  We suggest you use this shorcut instead: '#{suggested_shortcut}'")
    end
  end

  # Checks the shortcut to ensure the string is HTML safe.
  def shortcut_html_safe?
    errors.add(:shortcut, "Shortcut cannot contain illegal URL characters (Legal characters: a-z, A-Z, 0-9, '-', '_')") if !shortcut.nil? and shortcut != parameterize(shortcut)
  end




  ####################################################################
  # Scopes
  ###########

  scope :displayed, where(:displayed => true)
  scope :similar_shortcuts, lambda {|sc| where('UPPER(nodes.shortcut) LIKE UPPER(?)', "%"+sc+"%") unless sc.blank?}
  







  ####################################################################
  # Helpers
  ###########

  # Returns the URL of this node.
  def url(params={})
    url_params = params == {} ? '' : "?"+params.collect {|key,val| "#{key.to_s}=#{val.to_s}"}.join('&')
    return "/#{shortcut}" + url_params
  end

  

  # Returns the correct string for the route to call 'render' on
  # Ex. node.page = 'Blog' --> node.page_template = 'blogs/show'
  def template_path
    str = page_type
    return ("page_templates/"+str.pluralize)
  end
  
  # Return this node's page_type.  Returns nil if there is no assigned page_type
  def page_type
    association = nil
    NODE_PAGE_TYPES.keys.each {|assoc| association = assoc unless self.send(assoc).nil?}
    association
  end

  # Sets this node's shortcut to the desired shortcut or closest related shortcut that will be unique in the database.  If a conflict
  # occurs than a numeric increment will be appended as a prefix and the increment number will be returned.  If no conflict occured
  # than the method will return 0 (or the passed in increment if one was passed in)
  def set_safe_shortcut(shtcut=nil)
    shtcut ||= self.shortcut || ''
    node_id = self.id || 0
    desired_shortcut = parameterize(shtcut.clone) # Clone since trouble with copying
    prefix = ""; incr = 0
    while Node.where('nodes.shortcut = ? AND nodes.id != ?', prefix + desired_shortcut, node_id).exists?
      incr += 1
      prefix = incr.to_s + "-"
    end
    self.shortcut = prefix + desired_shortcut
  end
  



  ####################################################################
  # Node Tree Creator
  ##########

  # Basic node hash for the node tree
  def tree_hash_value
    {
      :key => "node_#{self.id}".to_sym,
      :name => self.menu_name,
      :url => self.url,
      :options => {:class => "#{self.page_type} #{self.displayed ? '' : 'not-displayed'}"},
      :items => children.collect {|node| node.tree_hash_value }
    }
  end

  # Called to order the Node tree based on passed in json
  def self.order_tree(json)
#    self.update_all(['position = ?', nil])
    errors = self.order_helper(json)
    return errors
  end







  private 
  
  
  # Saves the path of ancestor nodes to this node
  # Sets this node's site_id to it's site's id
  def set_ancestry_path_and_site_scope
    self.class.unscoped do
      self.names_depth_cache = path.map(&:menu_name).join('/')
      self.site_scope_id = (root ? root.site.try(:id) : nil) 
    end
  end  

  # Ensures the fields for this node are all filled, and if not, attempts to fill them
  def fill_missing_fields
    self.title = menu_name || shortcut.try(:humanize) if title.blank?
    self.menu_name = title || shortcut.try(:humanize) if menu_name.blank?
    self.shortcut = parameterize(menu_name) || parameterize(title) if shortcut.blank?
    self.layout_name ||= set_layout_name
    self.positions = TEMPLATES[layout_name]["positions"]
  end  
  
  # Sets this node's layout to the default layout for this node's page_type.  
  # If no page_type, sets it to the DEFAULT_TEMPLATE layout
  def set_layout_name
    self.layout_name = page_type.nil? ? DEFAULT_TEMPLATE : NODE_PAGE_TYPES[page_type]["default_layout"]
  end
  
  

  # Actual behind the scenes ordering of the Node tree
  def self.order_helper( json, parent_id = nil)
    errors = []; position = 0
    json.each do |hash|
      node = self.find(hash['attr']['id'].delete('node_').to_i)
      if node# and !reserved_nodes.include?(node)
        node.position = position
        node.parent_id = parent_id
        errors << node unless node.save
      end
      errors << order_helper( hash['children'], node.id) if hash['children']
      position += 1
    end
    errors.flatten
  end



  # Replaces special characters in a string so that it may be used as part of a ‘pretty’ URL.
  def parameterize(parameterized_string, sep = '-')
    return parameterized_string if parameterized_string.blank?
    # Turn unwanted chars into the separator
    parameterized_string.gsub!(/[^a-zA-Z0-9\-_]+/, sep)
    unless sep.nil? || sep.empty?
      re_sep = Regexp.escape(sep)
      # No more than one of the separator in a row.
      parameterized_string.gsub!(/#{re_sep}{2,}/, sep)
      # Remove leading/trailing separator.
      parameterized_string.gsub!(/^#{re_sep}|#{re_sep}$/, '')
    end
    parameterized_string
  end


  # Node error logger TODO
  def log_problem_node(msg)
    logger.error "DB ********** Node Error **********"
    logger.error "Node (id: #{self.id || ''}, title: #{self.title || ''})"
    logger.error "Error: '#{msg}'"
    logger.error "DB ******** End Node Error ********"
  end

end

