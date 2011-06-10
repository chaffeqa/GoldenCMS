class Post < ActiveRecord::Base
  
  
  ####################################################################
  # Associations
  ###########
  belongs_to :blog

  # Associated Page attributes
  belongs_to :page
  has_one :parent_page, :through => :page, :source => :parent
  has_one :blog, :through => :parent_page, :source => :blog





  ####################################################################
  # Validations and Callbacks
  ###########

  #Validations
  validates :title, :presence => true
  
  #Callbacks
  before_validation :update_page
  after_save  :update_cache_chain
  before_destroy :update_cache_chain
  
  # Global method to trigger caching updates for all objects that rely on this object's information
  # This will be called in one of two cases:
  #   1) This object has changed, and effected cached objects need to recache
  #   2) An object has notified this object that it needs to recache 
  def update_cache_chain
    logger.debug "DB ********** Touching Post #{id} ********** "
    self.touch
    self.blog.try(:update_cache_chain)
  end

  def update_page
    page = self.page ? self.page : self.build_page
    unless title.blank?
      page.title =  title
      page.menu_name = title
      page.set_safe_shortcut(title)
    end
    page.displayed = true
    page.parent = blog.page if blog and blog.page
  end

end

