class Calendar < ActiveRecord::Base
  
  
  ####################################################################
  # Associations
  ###########
  has_many :events
  has_many :calendar_elems

  # Associated Node attributes
  has_one :node, :as => :page, :dependent => :destroy
  accepts_nested_attributes_for :node


  ####################################################################
  # Validations and Callbacks
  ###########

  validates :title, :presence => true, :uniqueness => true
  before_validation :update_node  
  after_save :update_cache_chain
  before_destroy :update_cache_chain
  
  # Global method to trigger caching updates for all objects that rely on this object's information
  # This will be called in one of two cases:
  #   1) This object has changed, and effected cached objects need to recache
  #   2) An object has notified this object that it needs to recache 
  def update_cache_chain
    logger.debug "DB ********** Touching Calendar #{title} ********** "
    self.touch
    self.calendar_elems.each {|elem| elem.try(:update_cache_chain) }
  end

  def update_node
    node = self.node ? self.node : self.build_node
    unless self.title.blank?
      node.title =  title
      node.menu_name = title
      node.set_safe_shortcut(title)
    end
    node.displayed = true
    node.layout = CALENDAR_TEMPLATE
    site = Site.first
    node.parent = site.get_node_by_shortcut(site.calendars_shortcut)
  end
end

