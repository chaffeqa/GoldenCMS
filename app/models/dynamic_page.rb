class DynamicPage < ActiveRecord::Base
  
  
  ####################################################################
  # Associations
  ###########

  # Associated Node attributes
  has_one :node, :as => :page, :dependent => :destroy, :autosave => true
  accepts_nested_attributes_for :node

  has_many :elements
  
  
  
  

  ####################################################################
  # Validations and Callbacks
  ###########

  #Validations
  validates :template_name, :inclusion => { :in => TEMPLATES.values }

  #Callbacks
  before_save :update_node
  after_save :update_cache_chain
  before_destroy :update_cache_chain
  
  # Global method to trigger caching updates for all objects that rely on this object's information
  # This will be called in one of two cases:
  #   1) This object has changed, and effected cached objects need to recache
  #   2) An object has notified this object that it needs to recache 
  def update_cache_chain
    unless self.marked_for_destruction?
      logger.debug "DB ********** Touching DynamicPage #{id} ********** "
      self.touch
    end
    if node
      logger.debug "DB ********** Touching Node #{node.title} ********** "
      self.node.touch
    end
  end

  # updates the attributes for each node for this item
  def update_node
    node.layout = self.template_name
  end
  
  
  
  
  ####################################################################
  # Helpers
  ###########

  def self.template_name_select
    [['<Default>',DEFAULT_TEMPLATE]] + TEMPLATES.keys.collect {|key| [key, TEMPLATES[key]] }
  end

  def underscore_template_name
    template_name.gsub(/ /, '_').underscore
  end  


end

