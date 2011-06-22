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
  
  #Callbacks
  before_save :create_html_id
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


  def create_html_id
    self.html_id = title.blank? ? "element-unnamed" : title.to_slug
  end

  # Select array
  def self.get_elem_select
    ELEM_TYPES
  end

  # Returns the string name of the elem table, otherwise returns 'no_element'
  def get_elem_table_name
    elem_type.try(:tableize) || 'no_element'
  end


end

