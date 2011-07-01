class NavigationElem < ActiveRecord::Base
  
  DISPLAY_TYPES = [
    ["Default", "multi_level"],
    ["Breadcrumbs", "breadcrumbs"],
    ["Current Level", "single_level"]
  ]
  
  
  ####################################################################
  # Associations
  ###########
  belongs_to :element
  



  ####################################################################
  # Validations and Callbacks
  ###########

  
  #Validations
  validates :display_type, :inclusion => { :in => DISPLAY_TYPES.collect {|human, database_value| database_value } }
  validates :special_class, :format => { :allow_blank => true, :with => /^[a-zA-Z0-9-]+$/, :message => 'can only contain lowercase alphanumeric characters and dashes.'}





  ####################################################################
  # Helper Methods
  ###########
  
  def full_html_class
    [display_type, special_class].join(" ")
  end
  
  def self.display_type_select
    DISPLAY_TYPES#.collect {|human, database_value| human, database_value }
  end

end

