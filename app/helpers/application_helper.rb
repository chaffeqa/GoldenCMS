module ApplicationHelper
  
  # Redirects the request to the new site path
  def instantiate_site
    redirect_to(new_admin_sites_path, :error => "No site currently exists, pleace create one")
    return false
  end
  
  
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
  
  ########################
  # SITE CACHING ACTIONS #
  ########################

  def render_with_cache(key = request.fullpath, options = nil)
    body = Rails.cache.read(key)
    if body
      logger.debug log_format("CACHE","Read Cache key: #{key.to_s}")
      render :text => body
    else
      yield if block_given?
      render unless performed?
      Rails.cache.write(key, response.body, options)
      logger.debug log_format("CACHE","Write Cache key: #{key.to_s}")
    end
  end
   


  
end

