class ApplicationController < ActionController::Base
  include SearchHelper, ApplicationHelper, LoggingHelper
  
  protect_from_forgery
  rescue_from ActiveRecord::RecordNotFound, :with => :error_rescue
  rescue_from ActionController::RoutingError, :with => :error_rescue
  
  # Include all the helper files always
  helper :all
  # Make these controller methods accessable from everywhere
  helper_method :get_node, :admin?
  # Run these methods on every request
  before_filter :parse_filter_params, :get_site
  after_filter :add_flash_to_header
  # Fallback on the config-set default template layout
  layout DEFAULT_TEMPLATE



  ##################
  # FILTER METHODS #
  ##################

  # Find or instantiate the current site
  def get_site
    logger.debug log_format("FILTER", "Called get_site Before_Filter")
    @current_site ||= Site.get_subdomain(request.subdomain)
    return instantiate_site unless @current_site and @current_site.node
    set_site_name(@current_site.site_name)
    return true
  end

  # Find or Instantiates the current @node.  Check the node for validity.
  def get_node
    logger.debug log_format("FILTER", "Called get_node Before_Filter")
    @node ||= @current_site.get_node_by_shortcut(params[:shortcut])
    return false unless node_valid? and request_valid?
    set_page_title(@node.title)
    return true
  end

  #TODO Returns true or false if user is admin
  def admin?
    true #    admin_signed_in?
  end

  # Checks if User is an admin; Redirects if not
  def check_admin
    return render_error_status(422, "Unnauthorized access. Request IP: '#{request.remote_ip}'") unless admin?
    return true
  end
  
  # Renders our error pages, with passed in status and log message.  Returns false
  def render_error_status(status=500, log_msg = "")
    logger.error log_format("REQUEST","Rendering #{status}: #{log_msg}. Request URI: #{request.url}")
    render :file => "#{Rails.root}/public/#{status}.html", :status => status, :layout => false
    return false
  end
  
  

  private
  
  # Method for instantiating the search filter params
  def parse_filter_params
    parse_search_params(params)
  end

  # If the request is an AJAX one, stashes the flash into the response headers
  def add_flash_to_header
    # only run this in case it's an Ajax request.
    return unless request.xhr?
    # add different flashes to header
    response.headers['X-Flash-Error'] = flash.now[:error] unless flash.now[:error].blank?
    response.headers['X-Flash-Notice'] = flash.now[:notice] unless flash.now[:notice].blank?
  end

  # Renders a 404 page if an active record error occurs
  def error_rescue(exception = nil)
    return render_error_status(404, exception.message)
  end
  
  
  
  



  ##########################
  # NODE VALIDATITY CHECKS #
  ##########################

  # Checks the validity of the current node as well as the basic access rights
  def node_valid?
    # Node isn't valid
    return render_error_status(404, "No Node Found") if @node.nil?
    # Page not displayed and not admin
    return render_error_status(404, "Shortcut: '#{@node.shortcut}' not publicly displayed") if not @node.displayed and not admin?
    return true
  end
  
  # Checks the validity of the current node as well as the basic access rights
  def request_valid?
    # Invalid request format TODO refactor this to allow whitelist of formats
    return render_error_status(404, "Invalid Shortcut Request Format: '#{request.format}'") if request.format.blank?
    return true
  end
    

  # Helper for redirects if there is an error.
  def error_redirect(message="", status=500, shortcut="")
    if shortcut.blank? and message.blank?
      return render_error_status(status,"No Shortcut, no Message")
    else
      redirect_to(error_path(:message => message, :shortcut => shortcut, :status => status))
    end
    return false
  end


end

