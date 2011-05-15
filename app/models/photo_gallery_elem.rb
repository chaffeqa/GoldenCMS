class PhotoGalleryElem < ActiveRecord::Base
  
  ####################################################################
  # Associations
  ###########
  has_many :image_elems, :dependent => :destroy
  has_one :element, :as => :elem, :dependent => :destroy, :validate => true, :autosave => true
  accepts_nested_attributes_for :element

  DISPLAY_TYPE = [
    "Gallery with Uncropped Thumbnails",
    "Gallery with Uncropped Thumbnails and No Captions"#,
    #"Slideshow"
  ]




  ####################################################################
  # Validations and Callbacks
  ###########

  #Validations
  validates :display_type, :inclusion => { :in => DISPLAY_TYPE }
  
  #Callbacks
  
  # Global method to trigger caching updates for all objects that rely on this object's information
  # This will be called in one of two cases:
  #   1) This object has changed, and effected cached objects need to recache
  #   2) An object has notified this object that it needs to recache 
  def update_cache_chain
    logger.debug "DB ********** Touching PhotoGalleryElem #{id} ********** "
    self.touch
    self.element.try(:update_cache_chain)
    self.image_elems.each {|elem| elem.try(:update_cache_chain) } if image_elems
  end






  ####################################################################
  # Helper Methods
  ###########
  def self.display_type_select
    DISPLAY_TYPE
  end

  def display_type_partial
    self.display_type.downcase.gsub(" ", "_")
  end
end
