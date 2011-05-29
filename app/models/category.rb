class Category < ActiveRecord::Base

  ####################################################################
  # Associations
  ###########
  has_many :item_list_elems, :dependent => :destroy

  # Associated Node attributes
  belongs_to :node
  has_one :parent_node, :through => :node, :source => :parent, :class_name => 'Node'
  has_one :parent_category, :class_name => 'Category', :through => :parent_node, :source => :category
  has_many :item_pages, :through => :node, :source => :item_pages
  has_many :items, :through => :item_pages

  has_attached_file :image,
    :storage => :s3,
    :s3_credentials => S3_CREDENTIALS,
    :path => "/categories/:id/image_:style.:extension",
    :styles => { :thumb => ['154x169>', :png] }

#  has_attached_file :image,
#    :url  => "/site_assets/categories/:id/image_:style.:extension",
#    :path => ":rails_root/public/site_assets/categories/:id/image_:style.:extension",
#    :styles => { :thumb => ['154x169>', :png] }





  ####################################################################
  # Validations and Callbacks
  ###########

  validates :title, :presence => true, :uniqueness => true
  #before_validation :update_node
  #after_save  :update_cache_chain
  #before_destroy :update_cache_chain
  
  # Global method to trigger caching updates for all objects that rely on this object's information
  # This will be called in one of two cases:
  #   1) This object has changed, and effected cached objects need to recache
  #   2) An object has notified this object that it needs to recache 
  def update_cache_chain
    logger.debug "DB ********** Touching Category #{title} ********** "
    self.touch
    self.item_list_elems.each {|elem| elem.try(:update_cache_chain) }
  end


  def update_node
    node = self.node ? self.node : self.build_node
    unless self.title.blank?
      node.title =  title
      node.menu_name = title
      node.set_safe_shortcut(title)
    end
    node.displayed = true
    site = Site.first
    node.parent = (parent_category and !parent_category_id.blank?) ? parent_category.node : site.get_node_by_shortcut(site.categories_shortcut)
  end


  ####################################################################
  # Scopes
  ###########

  scope :title_like, lambda {|title| where('UPPER(title) LIKE UPPER(?)', title)}

  # Returns true if this category has an item
  def has_items?
    return !items.empty?
  end



  ####################################################################
  # Helpers
  ###########

  def thumbnail_image
    self.image? ? self.image.url(:thumb) : 'no_image_thumb.gif'
  end
  def original_image
    self.image? ? self.image.url : 'no_image_full_size.gif'
  end

end

