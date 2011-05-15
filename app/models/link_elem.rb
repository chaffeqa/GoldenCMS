class LinkElem < ActiveRecord::Base

  TARGET_OPTIONS = [ '', '_blank' ]
  LINK_TYPE_OPTIONS = [ 'Page', 'Url', 'File' ]
  
  
  ####################################################################
  # Associations
  ###########
  has_one :element, :as => :elem, :dependent => :destroy, :validate => true, :autosave => true
  belongs_to :node
  belongs_to :image, :class_name => 'Ckeditor::Picture'
  accepts_nested_attributes_for :element

  has_attached_file :link_file,
    :storage => :s3,
    :s3_credentials => S3_CREDENTIALS,
    :path => '/site_assets/files/link_file_:id.:extension'




  ####################################################################
  # Validations and Callbacks
  ###########

  #Validations
  validates :link_name, :presence => true
  validates :link_type, :presence => true, :inclusion => { :in => LINK_TYPE_OPTIONS }
  validates :target, :inclusion => { :in => TARGET_OPTIONS }, :allow_blank => true
  
  #Callbacks
  
  # Global method to trigger caching updates for all objects that rely on this object's information
  # This will be called in one of two cases:
  #   1) This object has changed, and effected cached objects need to recache
  #   2) An object has notified this object that it needs to recache 
  def update_cache_chain
    logger.debug "DB ********** Touching LinkElem #{id} ********** "
    self.touch
    self.element.try(:update_cache_chain)
  end




  ####################################################################
  # Helper Methods
  ###########

  def self.link_type_options
    LINK_TYPE_OPTIONS
  end
end

