class ItemPage < ActiveRecord::Base
  
  
  ####################################################################
  # Associations
  ###########
  belongs_to :item
  belongs_to :node
  has_one :parent_node, :through => :node, :source => :parent
  has_one :category, :through => :parent_node, :source => :category, :counter_cache => :item_count




  ####################################################################
  # Validations and Callbacks
  ###########

  # NOTE this is now called from the ITEM callback
  before_validation :update_node  

  # updates the attributes for each node for this item
  def update_node(name=nil)
    logger.debug "DB **********  calling item_category#update_node ********** "
    logger.debug "DB **********  passed in name: #{name.to_s} ********** "
    name ||= self.item.name #(force_reload = true) # force reload ensures item is pulled from DB instead of memory
    logger.debug "DB **********  name after lookup: #{name.to_s} ********** "
    node = self.node ? self.node : self.build_node
    unless name.blank?
      node.title = name
      node.menu_name = name
      node.set_safe_shortcut(name)
    end
    node.displayed = item.display
    node.parent = category.node
  end
end

