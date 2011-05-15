class ImageElem < ActiveRecord::Base

  ###############################
  ### ASSOCIATIONS
  ###############################

  has_one :element, :as => :elem, :dependent => :destroy, :validate => true, :autosave => true
  accepts_nested_attributes_for :element

  has_attached_file :image,
    :storage => :s3,
    :s3_credentials => S3_CREDENTIALS,
    :path => "/image_elems/:id/image_:style.:extension",
#    :processors => [:cropper],
    :styles => { :thumb => ["80x80^#", :png] }

  # Setup accessible (or protected) attributes for your model
  attr_protected :image_file_name, :image_content_type, :image_file_size
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h




  ####################################################################
  # Validations and Callbacks
  ###########

  #Validations
  validates_attachment_size :image, :less_than => 2.megabytes
  validates_attachment_content_type :image, :content_type => [ 'image/jpeg', 'image/png', 'image/gif', 'image/x-png', 'image/pjpeg' ]
  
  #  after_update :reprocess_image, :if => :cropping?
  
  # Global method to trigger caching updates for all objects that rely on this object's information
  # This will be called in one of two cases:
  #   1) This object has changed, and effected cached objects need to recache
  #   2) An object has notified this object that it needs to recache 
  def update_cache_chain
    logger.debug "DB ********** Touching ImageElem #{id} ********** "
    self.touch
    self.element.try(:update_cache_chain)
  end




  ###############################
  ### HELPERS
  ###############################

  # Image Geometry for cropping
  def image_geometry(style=:original)
    unless image.url.blank? or image.url.include?('missing.png')
      @geometry ||= {}
      return file_geometry if style == :original
      w, h = image.options[:styles][style][0].gsub(/[#^]/,"").split("x")
      @geometry[style] ||= Paperclip::Geometry.new(w, h)
      return @geometry[style]
    end
    return Paperclip::Geometry.new(0, 0)
  end
  def file_geometry
    @geometry[:original] ||= Paperclip::Geometry.from_file(image.to_file(:original))
    @geometry[:original]
  end

  # Returns true if the action is a 'cropping' action
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end


  ###########################################
  ############ PROTECTED METHODS ############
  ### Never called from outside the class ###
  ###########################################
  protected

  def reprocess_image
    image.reprocess!
  end

end

