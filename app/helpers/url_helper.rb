module UrlHelper
  def with_subdomain(subdomain)
    subdomain ||= ""
    subdomain += "." unless subdomain.blank?
    [subdomain, request.domain, request.port_string].join
  end
  
  def url_for(options = {})
    if options.kind_of?(Hash) 
      if options.has_key?(:subdomain)
        options[:host] = with_subdomain(options.delete(:subdomain))
      else
        options[:host] = with_subdomain(@current_site ? @current_site.subdomain : '')
      end
    end
    super
  end
end
