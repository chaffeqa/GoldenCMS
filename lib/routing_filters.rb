class Subdomain
 def self.matches?(request)
   request.subdomain.present? && request.subdomain != "www"
 end
end

class FilterRequest
  def self.matches?(request)
    puts "Request incoming with MIME format: #{request.format}"
    return request.format == Mime::HTML
    #raise ActionController::RoutingError, "Format #{params[:format].inspect} not supported for #{request.path.inspect}"
  end
end



