class Item < ActiveRecord::Base

  ####################################################################
  # Associations
  ###########
  has_many :product_images, :limit => 10, :dependent => :destroy
  has_one :main_image, :class_name => "ProductImage", :conditions => {:primary_image => true}, :dependent => :destroy
  accepts_nested_attributes_for :product_images, :allow_destroy => true, :reject_if => proc { |attributes| attributes['image'].blank? and attributes['id'].blank? }


  # Associated Node attributes
  belongs_to :node
  has_many :item_pages, :dependent => :destroy
  has_many :categories, :through => :item_pages
  accepts_nested_attributes_for :item_pages, :allow_destroy => true #, :reject_if => proc { |attr| attr['category_id'].blank?}



  ####################################################################
  # Validations and Callbacks
  ###########

  #Validations
  validates :name, :presence => true
  validates :part_number, :presence => true
  validates :cost, :presence => true, :numericality => true

  #Callbacks
  #before_validation :update_node
  #after_save        :update_cache_chain
  #after_save        :update_item_categories
  #before_destroy    :update_cache_chain
  
  # Global method to trigger caching updates for all objects that rely on this object's information
  # This will be called in one of two cases:
  #   1) This object has changed, and effected cached objects need to recache
  #   2) An object has notified this object that it needs to recache 
  # Since autosave doesn't seem to be working, this will force the item_categories to resave
  def update_cache_chain
    logger.debug "DB ********** Touching Item #{id} ********** "
    self.touch
    self.item_elems.each {|elem| elem.try(:update_cache_chain) }
  end
  
  # Since autosave doesn't seem to be working, this will force the item_categories to resave
  def update_item_categories
    (item_categories.each {|ic| ( ic.save) unless ic.marked_for_destruction? }) if item_categories
  end

  # updates the attributes for each node for this item
  def update_node
    node = self.node ? self.node : self.build_node
    unless name.blank?
      node.title = name
      node.menu_name =  name
      node.set_safe_shortcut(name)
    end
    node.displayed = self.display || true
    site = Site.first
    node.parent = site.get_node_by_shortcut(site.items_shortcut)
  end




  ####################################################################
  # Scopes
  ###########
  scope :get_for_sale, where(:for_sale => true)
  scope :displayed, where(:display => true)
  scope :scope_display, lambda {|display| where(:display => display) unless display.blank?}
  scope :scope_for_sale, lambda {|for_sale| where(:for_sale => for_sale) unless for_sale.blank?}
  scope :scope_name, lambda {|name| where('UPPER(name) LIKE UPPER(?)', '%'+name+'%') unless name.blank?}
  scope :scope_description, lambda {|desc| where('UPPER(short_description) LIKE UPPER(?) OR UPPER(long_description) LIKE UPPER(?)', "%"+desc+"%", "%"+desc+"%") unless desc.blank?}
  scope :scope_part_number, lambda {|part_number| where('UPPER(part_number) LIKE UPPER(?)', "%"+part_number+"%") unless part_number.blank?}
  scope :scope_category, lambda {|title| includes(:categories).where('UPPER(categories.title) LIKE UPPER(?)', "%"+title+"%") unless title.blank?}
  scope :scope_text, lambda {|text| where('UPPER(short_description) LIKE UPPER(?) OR UPPER(long_description) LIKE UPPER(?) OR UPPER(name) LIKE UPPER(?) OR UPPER(part_number) LIKE UPPER(?)', "%"+text+"%", "%"+text+"%", "%"+text+"%", "%"+text+"%") unless text.blank?}
  scope :scope_min_price, lambda {|price| where('cost >= ?', price) unless price.blank?}
  scope :scope_max_price, lambda {|price| where('cost <= ?', price) unless price.blank?}
  scope :scope_price_range, lambda {|range| ( scope_min_price(range.split('-')[0]).scope_max_price(range.split('-')[1]) ) unless range.blank? }
  scope :scope_ids, lambda {|item_ids| (where(:id => item_ids)) unless item_ids.empty? or item_ids.nil?}

  # Site search
  def self.item_search(params={})
    search_words_array = params[:searchText].blank? ? [] : params[:searchText].split(" ")
    item_ids=[]; search_words_array.each {|word| item_ids = item_ids + self.scope_text(word).collect {|item| item.id } }; puts "ids: " + item_ids.join(', ')
    items = self.displayed.scope_ids(item_ids).scope_category(params[:category]).scope_price_range(params[:cost_range])
    items = items.order(params[:sort] + " " + (params[:direction] || '')) unless params[:sort].blank?
    items
  end
  
  def self.admin_item_filters(params={})
    items = self.scope_display(params[:displayed]).scope_for_sale(params[:for_sale]).scope_category(params[:category])
    items = items.scope_part_number(params[:part_number]).scope_name(params[:name])
    items = items.scope_max_price(params[:max_price]).scope_min_price(params[:min_price])
    items = items.order(params[:sort] + " " + params[:direction] || '') unless params[:sort].blank?
    items
  end



  ####################################################################
  # Helpers
  ###########

  # Returns true if a better menu heirarchy url for this item exists
  def has_better_url?
    not self.item_categories.empty?
  end

  # Returns the best menu heirarchy url for this item
  def better_url
    self.has_better_url? ? self.item_categories.first.node.shortcut : self.node.shortcut
  end


  def thumbnail_image
    self.main_image ? self.main_image.thumbnail_image : 'no_image_thumb.gif'
  end

  def original_image
    self.main_image ? self.main_image.full_size_image : 'no_image_full_size.gif'
  end


end

