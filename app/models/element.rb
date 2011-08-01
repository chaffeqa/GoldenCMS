class Element < ActiveRecord::Base
  
  
  ####################################################################
  # Associations
  ###########
  belongs_to :page
  acts_as_list :scope => 'page_id = \'#{page_id}\' AND element_area = \'#{element_area}\'' # :scope => proc { ["page_id = ? AND element_area = ?", page_id, element_area] }
  
  ELEM_TYPES.each do |human_name, elem_table|
    has_one elem_table.singularize.to_sym
    accepts_nested_attributes_for elem_table.singularize.to_sym
  end




  ####################################################################
  # Validations and Callbacks
  ###########

  #Validations
  validates :title, :presence => true
  validates :element_area, :presence => true, :numericality => true
  validates :page_id, :presence => true, :numericality => true
  validates :html_id, :presence => true
  validates :html_class, :presence => true
  validate :html_attr_html_safe
  
  #Callbacks
  before_validation { 
    self.html_id ||= title.try(:to_slug)
    self.html_class ||= title.try(:to_slug)
  }
  #after_save :update_cache_chain
 # before_destroy :update_cache_chain
  
  # Global method to trigger caching updates for all objects that rely on this object's information
  # This will be called in one of two cases:
  #   1) This object has changed, and effected cached objects need to recache
  #   2) An object has notified this object that it needs to recache 
  def update_cache_chain
    logger.debug "DB ********** Touching Element #{id} ********** "
    self.touch
    self.dynamic_page.try(:update_cache_chain)
  end


  # Scopes

  # Returns the elements ordered from highest (first) to lowest (last)
  scope :elem_order, order('position asc')
  # Returns all Elements with the position passed in
  scope :element_area_elems, lambda {|element_area| where(:element_area => element_area) }
  # Returns the ordered elements for the passed in position
  scope :elements_for_element_area, lambda {|element_area| element_area_elems(element_area).elem_order }


  # Adds an error on html_id or html_class if either is not HTML safe
  def html_attr_html_safe 
    errors.add(:html_id, "cannot contain illegal URL characters (Legal characters: a-z, A-Z, 0-9, '-')") if !html_id.nil? and html_id != html_id.to_slug
    errors.add(:html_class, "cannot contain illegal URL characters (Legal characters: a-z, A-Z, 0-9, '-')") if !html_class.nil? and html_class != html_class.to_slug
  end

  # Return this the name of the object this element is a 'element for' (ex. 'text_elems' if this page represents a Text Element)
  # Returns nil if there is no assigned elem_type
  def elem_type
    association = nil    
    ELEM_TYPES.each {|human, table_name| association = table_name unless self.try(table_name.singularize).nil?}
    association
  end    
  
  # Returns the elem object of this element.  Returns nil if no elem exists.
  def elem_object
    return self.send(elem_type.singularize.intern) if elem_type
    nil
  end


  # Select array for element types
  def self.get_elem_select
    ELEM_TYPES.map { |human, table_name| [human, table_name.singularize] }
  end

  # Returns the string name of the elem table, otherwise returns 'no_element'
  def elem_table_name
    elem_type || 'no_element'
  end
  
  # Returns a string representing this Element's html class
  def full_html_class 
    [elem_table_name,html_class].join(" ")
  end
    
  # Returns a string representing this Element's html class
  def full_html_id
    html_id
  end

end

