class Blog < ActiveRecord::Base
  
  
  ####################################################################
  # Associations
  ###########
  has_many :blog_elem_links, :dependent => :destroy
  has_many :blog_elems, :through => :blog_elem_links

  # Associated Page attributes
  belongs_to :page
  has_many :posts, :through => :page


  ####################################################################
  # Validations and Callbacks
  ###########

  # Validations
  validates :title, :presence => true, :uniqueness => true
  
  # Callbacks
  #before_validation :update_page
  #after_save :update_cache_chain
  #before_destroy :update_cache_chain
  
  # Global method to trigger caching updates for all objects that rely on this object's information
  # This will be called in one of two cases:
  #   1) This object has changed, and effected cached objects need to recache
  #   2) An object has notified this object that it needs to recache 
  def update_cache_chain
    logger.debug "DB ********** Touching BlogElem #{id} ********** "
    self.touch
    self.blog_elems.each {|elem| elem.try(:update_cache_chain) }
  end

  def update_page
    self.title = unique_title if self.title.blank?
    page = self.page ? self.page : self.build_page
    page.title =  title
    page.menu_name = title
    page.set_safe_shortcut(title)
    page.displayed = true
    site = Site.first
    page.parent = site.initialize_requested_page_by_shortcut(site.blogs_shortcut)
  end

  private

  def unique_title(i="")
    potential_title = "Blog#{i.to_s}"
    if Blog.where(:title => potential_title).exists?
      i = (i == "" ? 1 : i + 1 )
      return unique_title(i)
    else
      return potential_title
    end
  end

end

