class DynamicPage < ActiveRecord::Base
  
  
  ####################################################################
  # Associations
  ###########

  # Associated Node attributes
  belongs_to :node, :inverse_of => :dynamic_page
  has_many :elements
  
  
  
  

  ####################################################################
  # Validations and Callbacks
  ###########

  #Validations
  validates :template_name, :inclusion => { :in => TEMPLATES.values.collect {|hash| hash["template_name"] } }
  validates :positions, :presence => true, :numericality => true

  #Callbacks
  before_validation :fill_attributes
  #after_save :update_cache_chain
  #before_destroy :update_cache_chain
  
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
  def fill_attributes
    puts "called"
    if self.node.present?
      self.template_name = TEMPLATES[node.layout_name]["template_name"]
      self.positions = TEMPLATES[node.layout_name]["positions"]
    end
  end
  
  
  
  
  ####################################################################
  # Helpers
  ###########



end

