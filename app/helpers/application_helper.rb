module ApplicationHelper

  # Redirects the request to the new Administrative Account path
  def instantiate_first_admin
    flash[:alert] = "No Administrator account currently exists, please create one"
    redirect_to(new_administrator_registration_path)
    return false
  end
  
  # Redirects the request to the new site path
  def instantiate_site
    flash[:alert] = "No site currently exists, please create one"
    redirect_to(new_admin_sites_path)
    return false
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

