class BlogElemLink < ActiveRecord::Base
  
  
  ####################################################################
  # Associations
  ###########
  belongs_to :blog
  belongs_to :blog_elem
end
