class Event < ActiveRecord::Base
  
  
  ####################################################################
  # Associations
  ###########
  has_event_calendar

  # Associated Page attributes
  belongs_to :page
  has_one :parent_page, :through => :page, :source => :parent
  has_one :calendar, :through => :parent_page



  ####################################################################
  # Validations and Callbacks
  ###########

  #Validations
  validates :name, :presence => true, :uniqueness => true
  #before_validation :update_page
  #after_save :update_cache_chain
  #before_destroy :update_cache_chain
  
  # Global method to trigger caching updates for all objects that rely on this object's information
  # This will be called in one of two cases:
  #   1) This object has changed, and effected cached objects need to recache
  #   2) An object has notified this object that it needs to recache 
  def update_cache_chain
    logger.debug "DB ********** Touching Event #{id} ********** "
    self.touch
    self.calendar.try(:update_cache_chain)
  end

  def update_page
    page = self.page ? self.page : self.build_page
    unless self.name.blank?
      page.title =  name
      page.menu_name = name
      page.set_safe_shortcut(name)
    end
    page.displayed = true
    self.page.parent = calendar.page if calendar and calendar.page
  end
end
