class ItemPage < ActiveRecord::Base
  
  
  ####################################################################
  # Associations
  ###########
  belongs_to :item
  belongs_to :page
  has_one :parent_page, :through => :page, :source => :parent
  has_one :category, :through => :parent_page, :source => :category, :counter_cache => :item_count




  ####################################################################
  # Validations and Callbacks
  ###########

  # NOTE this is now called from the ITEM callback
  before_validation :update_page  

  # updates the attributes for each page for this item
  def update_page(name=nil)
    logger.debug "DB **********  calling item_category#update_page ********** "
    logger.debug "DB **********  passed in name: #{name.to_s} ********** "
    name ||= self.item.name #(force_reload = true) # force reload ensures item is pulled from DB instead of memory
    logger.debug "DB **********  name after lookup: #{name.to_s} ********** "
    page = self.page ? self.page : self.build_page
    unless name.blank?
      page.title = name
      page.menu_name = name
      page.set_safe_shortcut(name)
    end
    page.displayed = item.display
    page.parent = category.page
  end
end

