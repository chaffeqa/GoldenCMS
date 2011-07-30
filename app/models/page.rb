class Page < ActiveRecord::Base
  
  
  ####################################################################
  # Associations
  ###########
  belongs_to :site
  belongs_to :root_site, :class_name => 'Site'
  has_ancestry :cache_depth => true, :orphan_strategy => :rootify  
  #acts_as_list :scope => proc { ["ancestry = '?'", ancestry] }
  acts_as_list :scope => 'ancestry = \'#{ancestry}\''
  has_many   :link_elems, :dependent => :destroy
  has_many :elements
  
  # Creates associations for each accepted page page type
  SPECIAL_PAGE_TYPES.keys.each do |page_type|
    has_one page_type.to_sym
    accepts_nested_attributes_for page_type.to_sym
    #has_many page_type.pluralize.to_sym, :through => :children, :source => page_type.to_sym
  end



  ####################################################################
  # Validations and Callbacks
  ###########

  #Validations
  validates :shortcut, :presence => {:allow_blank => true}, :uniqueness => {:scope => :root_site_id, :allow_blank => true}
  validates :title, :presence => true
  validates :menu_name, :presence => true
  validates :layout_name, :inclusion => { :in => TEMPLATES.keys }  
  validates :total_element_areas, :presence => true, :numericality => true
  validate :shortcut_html_safe?
  validate :reserved_page_violation?, :on => :update
  #validate :check_unique_shortcut?

  #Callbacks
  before_validation :fill_missing_fields
  before_save :set_ancestry_path_and_root_site
  #after_save :update_cache_chain
  #before_destroy :update_cache_chain
  
  # Global method to trigger caching updates for all objects that rely on this object's information
  # This will be called in one of two cases:
  #   1) This object has changed, and effected cached objects need to recache
  #   2) An object has notified this object that it needs to recache 
  # Clears the cache items of Page calls
  def update_cache_chain
    unless self.marked_for_destruction?
      logger.debug "DB ********** Touching Page #{title} ********** "
      self.touch
    end
    if parent
      logger.debug "DB ********** Touching Page #{parent.title} ********** "
      self.parent.touch
    end
    if root and root.site
      logger.debug "DB ********** Touching Site #{root.site.subdomain} ********** "
      self.root.site.touch if self.root.site
    end
    self.link_elems.each {|elem| elem.try(:update_cache_chain) }
  end

  # Tests to see if the page changes violate the basic structural rules
  def hierarchy_structure_violation?
    # Validation if this page has no parent and is not the root page
    errors.add(:parent_id, "This page must be part of the site menu hierarchy") if parent_id.blank? and site.blank?
  end

  # Tests to see if the page changes violate the reserved page rules
  def reserved_page_violation?
    # Validation if this is a reserved page being updated...
    if root_site and root_site.reserved_pages.collect {|n| n.id}.include?(self.id)
      errors.add(:base, "You cannot adjust reserved menu page shortcuts.  Reserved menu items include: #{this_pages_site.reserved_shortcuts.join(', ')}") unless root_site.reserved_shortcuts.include?(shortcut)
    end
    # Validation if this Home page
    #errors.add(:parent_id, "This page must be the root of the menu hierarchy") if self.site and !parent_id.blank?
  end

  # Checks the database to ensure the Shortcut is not already taken
  def check_unique_shortcut?
    if (not new_record? and Page.where('pages.shortcut = ? AND pages.id != ?', shortcut, id).exists?) or (new_record? and Page.where(:shortcut => shortcut).exists?)
      logger.warn "DB ********** Page Shortcut collision: (Title: #{title}, ID: #{id} URL: #{shortcut}), new_record: #{new_record?} ********** "
      addition = Page.where(:shortcut => shortcut).count
      suggested_shortcut = addition.to_s  + "-" + shortcut
      errors.add(:shortcut, "URL shortcut already exists in this site.  We suggest you use this shorcut instead: '#{suggested_shortcut}'")
    end
  end

  # Checks the shortcut to ensure the string is HTML safe.
  def shortcut_html_safe?
    errors.add(:shortcut, "Shortcut cannot contain illegal URL characters (Legal characters: a-z, A-Z, 0-9, '-', '_')") if !shortcut.nil? and shortcut != shortcut.to_slug #parameterize(shortcut)
  end




  ####################################################################
  # Scopes
  ###########

  scope :displayed, where(:displayed => true)
  scope :similar_shortcuts, lambda {|sc| where('UPPER(pages.shortcut) LIKE UPPER(?)', "%"+sc+"%") unless sc.blank?}
  scope :ordered, order("ancestry_depth, position DESC")







  ####################################################################
  # Helpers
  ###########

  # Returns the URL of this page.
  def url(params={})
    url_params = params == {} ? '' : "?"+params.collect {|key,val| "#{key.to_s}=#{val.to_s}"}.join('&')
    return "/#{shortcut}" + url_params
  end  

  # Returns the correct string for the route to call 'render' on
  # Ex. page.page_type = 'blog' --> page.template_to_use = 'blog'
  # Ex. page.page_type = nil --> page.template_to_use = 'dynamic_page'
  def template_path_to_render
    page_template = page_type.try(:to_s)
    page_template ||= 'inventory' if shortcut == root_site.inventory_shortcut
    page_template ||= 'dynamic_page'
    return "templates/#{page_template}"
  end
  
  # Return this the name of the object this page is a 'page for' (ex. 'category' if this page represents a Category)
  # Returns nil if there is no assigned page_type
  def page_type
    association = nil    
    SPECIAL_PAGE_TYPES.keys.each {|assoc| association = assoc unless self.send(assoc).nil?}
    association
  end    
  
  # Sets this page's shortcut to the desired shortcut or closest related shortcut that will be unique in the database.  If a conflict
  # occurs than a numeric increment will be appended as a prefix and the increment number will be returned.  If no conflict occured
  # than the method will return 0 (or the passed in increment if one was passed in)
  def find_safe_shortcut(shtcut='temp-shortcut')
    desired_shortcut = shtcut.to_slug #parameterize(shtcut.clone) # Clone since trouble with copying
    prefix = ""; incr = 0
    while Page.where('pages.shortcut = ? AND pages.id != ?', prefix + desired_shortcut, id || 0).exists?
      incr += 1
      prefix = incr.to_s + "-"
    end
    return (prefix + desired_shortcut)
  end
  
  # Create the array of options to populate a <select> element for setting the Page.layout
  def page_layout_select
    TEMPLATES.collect {|key,value| [key, value["human_name"]] }
  end
  



  ####################################################################
  # Page Navigation Methods
  ##########
  
  # Returns an array of pages representing the single level navigation to display
  # Note: if this page is the root page, will display its children << the root page
  def single_level_nav_pages
    if self.is_root?
      return children.displayed.order(:position).unshift(self)
    else
      return siblings.displayed.order(:position)
    end
  end
  
  def children_nav_pages
    if self.is_root?
      return children.displayed.order(:position).unshift(self)
    else
      return children.displayed.order(:position)
    end
  end

  # Basic hash for this Page. Used for constructing the page tree
  def tree_hash_value
    {
      :key => "page_#{self.id}".to_sym,
      :name => self.menu_name,
      :url => self.url,
      :options => {:class => "#{self.page_type} #{self.displayed ? '' : 'not-displayed'}"},
      :items => children.collect {|page| page.tree_hash_value }
    }
  end
  
  # Returns a hash representing this Page in a format that js_tree needs
  # @return Hash
  def js_tree_hash
  { 
      # Applied to the <a> attribute
      data: {
        title: menu_name,
        attr: { href: url }
      },
      # applied to the <li> attribute
      attr: { 
        id: "page_#{id}", 
        class: "#{page_type} #{displayed ? '' : 'not-displayed'}"
      }      
    }
  end

  # Called to order the Page tree based on passed in json
  def self.order_tree(json)
#    self.update_all(['position = ?', nil])
    errors = self.order_helper(json)
    return errors
  end






  private 
  
  # Saves the path of ancestor pages to this page
  # Sets this page's site_id to it's site's id
  def set_ancestry_path_and_root_site
    self.class.unscoped do
      self.names_depth_cache = path.map(&:menu_name).join('/')
      self.root_site = (root ? root.site : nil) 
    end
  end  

  # Ensures the fields for this page are all filled, and if not, attempts to fill them
  def fill_missing_fields
    self.title = menu_name || shortcut.try(:humanize) if title.blank?
    self.menu_name = title || shortcut.try(:humanize) if menu_name.blank?
    self.shortcut = (menu_name || title).to_slug if shortcut.blank? #parameterize(menu_name) || parameterize(title) if shortcut.blank?
    self.layout_name ||= set_layout_name
    self.total_element_areas = TEMPLATES[layout_name]["total_element_areas"]
  end  
  
  # Sets this page's layout to the default layout for this page's page_type.  
  # If no page_type, sets it to the DEFAULT_TEMPLATE layout
  def set_layout_name
    self.layout_name = page_type.nil? ? DEFAULT_TEMPLATE : SPECIAL_PAGE_TYPES[page_type]["default_layout"]
  end  

  # Actual behind the scenes ordering of the Page tree
  def self.order_helper( json, parent_id = nil)
    errors = []; position = 0
    json.each do |hash|
      page = self.find(hash['attr']['id'].delete('page_').to_i)
      if page# and !reserved_pages.include?(page)
        page.position = position
        page.parent_id = parent_id
        errors << page unless page.save
      end
      errors << order_helper( hash['children'], page.id) if hash['children']
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
  
  # Page error logger TODO
  def log_problem_page(msg)
    logger.error "DB ********** Page Error **********"
    logger.error "Page (id: #{self.id || ''}, title: #{self.title || ''})"
    logger.error "Error: '#{msg}'"
    logger.error "DB ******** End Page Error ********"
  end

end

