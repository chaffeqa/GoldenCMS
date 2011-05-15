class Event < ActiveRecord::Base
  
  
  ####################################################################
  # Associations
  ###########
  belongs_to :calendar, :touch => true
  has_event_calendar

  # Associated Node attributes
  has_one :node, :as => :page, :dependent => :destroy
  accepts_nested_attributes_for :node




  ####################################################################
  # Validations and Callbacks
  ###########

  #Validations
  validates :name, :presence => true, :uniqueness => true
  before_validation :update_node
  after_save :update_cache_chain
  before_destroy :update_cache_chain
  
  # Global method to trigger caching updates for all objects that rely on this object's information
  # This will be called in one of two cases:
  #   1) This object has changed, and effected cached objects need to recache
  #   2) An object has notified this object that it needs to recache 
  def update_cache_chain
    logger.debug "DB ********** Touching Event #{id} ********** "
    self.touch
    self.calendar.try(:update_cache_chain)
  end

  def update_node
    node = self.node ? self.node : self.build_node
    unless self.name.blank?
      node.title =  name
      node.menu_name = name
      node.set_safe_shortcut(name)
    end
    node.displayed = true
    self.node.parent = calendar.node if calendar and calendar.node
  end
end
