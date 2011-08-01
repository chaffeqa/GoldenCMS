module LayoutHelper
  #########################
  # SITE HEADER ACCESSORS #
  #########################
  
  def page_title
    @content_for_page_title ? @content_for_page_title : ''
  end
  
  def site_name
    @content_for_site_name ? @content_for_site_name : 'GoldenCMS'
  end

  def set_site_name(site_name)
    @content_for_site_name = site_name 
  end
  
  def set_page_title(title)
    @content_for_page_title =  title 
  end
end
