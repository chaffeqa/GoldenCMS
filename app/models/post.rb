class Post < ActiveRecord::Base
  
  
  ####################################################################
  # Associations
  ###########
  belongs_to :blog

  # Associated Node attributes
  belongs_to :node
  has_one :parent_node, :through => :node, :source => :parent
  has_one :blog, :through => :parent_node, :source => :blog





  ####################################################################
  # Validations and Callbacks
  ###########

  #Validations
  validates :title, :presence => true
  
  #Callbacks
  before_validation :update_node
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

  def update_node
    node = self.node ? self.node : self.build_node
    unless title.blank?
      node.title =  title
      node.menu_name = title
      node.set_safe_shortcut(title)
    end
    node.displayed = true
    node.parent = blog.node if blog and blog.node
  end

end

