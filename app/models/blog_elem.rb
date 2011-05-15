class BlogElem < ActiveRecord::Base
  
  DISPLAY_TYPE = [
    "Archive",
    "List",
    "List with Body"
  ]
  
  
  
  
  ####################################################################
  # Associations
  ###########
  has_one :element, :as => :elem, :dependent => :destroy, :validate => true, :autosave => true
  has_many :blog_elem_links, :dependent => :destroy
  has_many :blogs, :through => :blog_elem_links
  accepts_nested_attributes_for :element




  ####################################################################
  # Validations and Callbacks
  ###########

  #Validations
  validates_numericality_of :count_limit, :allow_blank => true
  validates :display_type, :inclusion => { :in => DISPLAY_TYPE }

  #Callbacks
  before_save :check_for_blogs
  
  # Global method to trigger caching updates for all objects that rely on this object's information
  # This will be called in one of two cases:
  #   1) This object has changed, and effected cached objects need to recache
  #   2) An object has notified this object that it needs to recache 
  def update_cache_chain
    logger.debug "DB ********** Touching BlogElem #{id} ********** "
    self.touch
    self.element.try(:update_cache_chain)
  end

  def check_for_blogs
    if self.blog_elem_links.empty?
      blog = self.element.title.blank? ? Blog.new() : Blog.new(:title => self.element.title)
      self.blogs << blog
      blog.save
    end
  end



  def self.display_type_select
    DISPLAY_TYPE
  end

  def display_type_partial
    self.display_type.downcase.gsub(" ", "_")
  end
end

