class Element < ActiveRecord::Base
  
  
  ####################################################################
  # Associations
  ###########
  belongs_to :page
  acts_as_list :scope => proc { ["page_id = ? AND element_area = ?", page_id, element_area] }
  
  ELEM_TYPES.each do |human_name, elem_table|
    has_one elem_table.signularize.to_sym
  end




  ####################################################################
  # Validations and Callbacks
  ###########

  #Validations
  validates :title, :presence => true
  validates :element_area, :numericality => true
  
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
    self.html_id = title.blank? ? "element-unnamed" : parameterize(title.clone.downcase)
  end

  # Select array
  def self.get_elem_select
    ELEM_TYPES
  end

  # Returns the string name of the elem controller
  def get_elem_controller
    elem_type.tableize
  end


  private

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


end

