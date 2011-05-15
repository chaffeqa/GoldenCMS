class Node < ActiveRecord::Base
  
  
  ####################################################################
  # Associations
  ###########
  belongs_to :page, :polymorphic => true
  belongs_to :category, :class_name => 'Category', :foreign_key => "page_id"
  belongs_to :item, :class_name => 'Item', :foreign_key => "page_id"
  has_one    :site, :autosave => true
  has_many   :link_elems, :dependent => :destroy

  acts_as_tree :order => 'position'
  acts_as_list :scope => :parent_id


  ####################################################################
  # Validations and Callbacks
  ###########

  #Validations
  validates :shortcut, :presence => true
  validates :title, :presence => true
  validates :menu_name, :presence => true
  validates :layout, :inclusion => { :in => TEMPLATES.values }
  validate :shortcut_html_safe?
  validate :check_unique_shortcut?
  validate :hierarchy_structure_violation?
  validate :reserved_node_violation?

  #Callbacks
  before_validation :fill_missing_fields
  # Sets this node's site_id to it's site's id
  before_save { self.site_id = (self.root ? root.site.id : nil) }
  after_save :update_cache_chain
  before_destroy :update_cache_chain
  
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

  # Ensures the fields for this node are all filled, and if not, attempts to fill them
  def fill_missing_fields
    unless self.title.blank?
      self.menu_name = self.title if self.menu_name.blank?
      self.shortcut = parameterize(self.title) if self.shortcut.nil?
    else
      unless self.menu_name.blank?
        self.title = self.menu_name if self.title.blank?
        self.shortcut = parameterize(self.menu_name) if self.shortcut.nil?
      end
    end
    self.layout = DEFAULT_TEMPLATE if self.layout.blank?
  end

  # Tests to see if the node changes violate the basic structural rules
  def hierarchy_structure_violation?
    # Validation if this node has no parent and is not the root node
    errors.add(:parent_id, "This page must be part of the site menu hierarchy") if parent_id.blank? and site.blank?
  end

  # Tests to see if the node changes violate the reserved node rules
  def reserved_node_violation?
    this_nodes_site = self.root ? self.root.site : nil
    # Validation if this is a reserved node being updated...
    if !self.new_record? and this_nodes_site.reserved_nodes.collect {|n| n.id}.include?(self.id) and !this_nodes_site.nil?
      errors.add(:base, "You cannot adjust reserved menu page shortcuts.  Reserved menu items include: #{this_nodes_site.reserved_shortcuts.join(', ')}") unless this_nodes_site.reserved_shortcuts.include?(self.shortcut)
    end
    # Validation if this Home node
    errors.add(:parent_id, "This page must be the root of the menu hierarchy") if self.site and !parent_id.blank?
  end

  # Checks the database to ensure the Shortcut is not already taken
  def check_unique_shortcut?
    if (not new_record? and Node.where('nodes.shortcut = ? AND nodes.id != ?', shortcut, id).exists?) or (new_record? and Node.exists?(:shortcut => shortcut))
      logger.warn "DB ********** Node Shortcut collision: (Title: #{title}, ID: #{id} URL: #{shortcut}), new_record: #{new_record?} ********** "
      addition = Node.where('shortcut LIKE ?', shortcut).count
      suggested = self.shortcut + "_" + addition.to_s
      errors.add(:shortcut, "URL shortcut already exists in this site.  Suggested Shortcut: '#{suggested}'")
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
  scope :dynamic_pages, where(:page_type => 'DynamicPage')
  scope :categories, where(:page_type => 'Category')
  scope :calendars, where(:page_type => 'Calendar')
  scope :items, where("nodes.page_type = 'Item' OR nodes.page_type = 'ItemCategory' ")
  scope :no_items, where("nodes.page_type != 'Item' OR nodes.page_type != 'ItemCategory' OR nodes.page_type IS NULL")
  scope :similar_shortcuts, lambda {|sc| where('UPPER(nodes.shortcut) LIKE UPPER(?)', "%"+sc+"%") unless sc.blank?}
  





  ####################################################################
  # Site specific methods
  ###########

  # Returns the URL of this node.
  def url(params={})
    url_params = params == {} ? '' : "?"+params.collect {|key,val| "#{key.to_s}=#{val.to_s}"}.join('&')
    if page
      return page.send(:better_url) + url_params
    else
      if !controller.blank? and !action.blank?
        if page_id.blank?
          return "/#{self.controller}/#{self.action}" + url_params
        else
          return "/#{self.controller}/#{self.action}/#{self.page_id}" + url_params
        end
      end
    end
    return "/#{self.shortcut}" + url_params
  rescue
    return "/#{self.shortcut}" + url_params
  end

  

  # Returns the correct string for the route to call 'render' on
  # Ex. node.page = 'Blog' --> node.page_template = 'blogs/show'
  def template_path
    str = (self.page_type == 'ItemCategory' ? 'Item' : self.page_type)
    return (str.tableize.pluralize + "/show")
  end




  ####################################################################
  # Helpers
  ###########

  # Returns true if this node has a valid page
  def has_page?
    !page_type.blank? and !page.nil?
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

  # Finds or Creates a node with the given shortcut, adds it to the home_node
  def self.find_or_create(shortcut='', display=true)
    unless shortcut.nil?
      return where(:shortcut => shortcut).first unless where(:shortcut => shortcut).empty?
      return self.home.children.create(:menu_name => shortcut.gsub('_',' ').capitalize, :title => shortcut.gsub('_',' ').capitalize, :shortcut => shortcut, :displayed => display)
    end
    nil
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
    # Turn unwanted chars into the separator
    parameterized_string.gsub!(/[^a-zA-Z0-9\-_]+/, sep)
    unless sep.nil? || sep.empty?
      re_sep = Regexp.escape(sep)
      # No more than one of the separator in a row.
      parameterized_string.gsub!(/#{re_sep}{2,}/, sep)
      # Remove leading/trailing separator.
      parameterized_string.gsub!(/^#{re_sep}|#{re_sep}$/, '')
    end
    parameterized_string.downcase
  end


  # Node error logger TODO
  def log_problem_node(msg)
    logger.error "DB ********** Node Error **********"
    logger.error "Node (id: #{self.id || ''}, title: #{self.title || ''})"
    logger.error "Error: '#{msg}'"
    logger.error "DB ******** End Node Error ********"
  end

end

