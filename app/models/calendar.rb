class Calendar < ActiveRecord::Base
  
  
  ####################################################################
  # Associations
  ###########
  has_many :calendar_elems

  # Associated Page attributes
  belongs_to :page
  has_many :events, :through => :page


  ####################################################################
  # Validations and Callbacks
  ###########

  validates :title, :presence => true, :uniqueness => true
  #before_validation :update_page  
  #after_save :update_cache_chain
  #before_destroy :update_cache_chain
  
  # Global method to trigger caching updates for all objects that rely on this object's information
  # This will be called in one of two cases:
  #   1) This object has changed, and effected cached objects need to recache
  #   2) An object has notified this object that it needs to recache 
  def update_cache_chain
    logger.debug "DB ********** Touching Calendar #{title} ********** "
    self.touch
    self.calendar_elems.each {|elem| elem.try(:update_cache_chain) }
  end

  def update_page
    page = self.page ? self.page : self.build_page
    unless self.title.blank?
      page.title =  title
      page.menu_name = title
      page.set_safe_shortcut(title)
    end
    page.displayed = true
    page.layout = CALENDAR_TEMPLATE
    site = Site.first
    page.parent = site.initialize_requested_page_by_shortcut(site.calendars_shortcut)
  end
end

