class ApplicationController < ActionController::Base
  include SearchHelper, ApplicationHelper, LoggingHelper, LayoutHelper
  
  protect_from_forgery
  rescue_from ActiveRecord::RecordNotFound, :with => :error_rescue
  rescue_from ActionController::RoutingError, :with => :error_rescue
  
  # Include all the helper files always
  helper :all
  # Make these controller methods accessable from everywhere
  helper_method :initialize_requested_page, :admin?
  # Run these methods on every request
  before_filter :check_administrative_account_count, :initialize_requested_site, :parse_filter_params
  after_filter :add_flash_to_header
  # Fallback on the config-set default template layout
  layout DEFAULT_TEMPLATE



  ##################
  # FILTER METHODS #
  ##################
  
  # Checks if there is no administrative account created
  def check_administrative_account_count
    logger.debug log_format("FILTER", "Called check_administrative_account_count, Admin count: #{Administrator.count}")
    # redirect if there is no administrative account yet
    return instantiate_first_admin if Administrator.count == 0
    return true
  end

  # Find or instantiate the current site
  def initialize_requested_site
    logger.debug log_format("FILTER", "Called initialize_requested_site Before_Filter for subdomains: '#{request.subdomains.join(', ')}', count: #{request.subdomains.count}")
    @requested_site ||= Site.find_by_subdomains(request.subdomains)
    return instantiate_site unless @requested_site and @requested_site.root_page
    set_site_name(@requested_site.site_name)
    return true
  end

  # Find or Instantiates the current @requested_page.  Check the page for validity.
  def initialize_requested_page
    logger.debug log_format("FILTER", "Called initialize_requested_page Before_Filter for shortcut: '#{params[:shortcut]}'")
    @requested_page ||= @requested_site.initialize_requested_page_by_shortcut(params[:shortcut])
    return false unless page_valid? and request_valid?
    set_page_title(@requested_page.title)
    return true
  end

  #Returns true or false if user is admin
  def admin?
    # Return true if this is dev mode (but doesnt break the site initialize building)
    return true if Rails.env.productions? and Administrator.count > 0
    administrator_signed_in?
  end

  # Checks if User is an admin.
  # Renders 422 error if admin is not logged in.
  # Exceptions include if there is no administrator account yet
  # @returns True or false
  def check_admin
    logger.debug log_format("FILTER", "Called check_admin")
    return true if Administrator.count == 0
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
  # Only performed if the request has a query string addition (ex. "http://foo.com?query=string")
  def parse_filter_params
    unless request.query_string.blank?
      parse_search_params(params)
    end
  end

  # If the request is an AJAX one, stashes the flash into the response headers
  def add_flash_to_header
    logger.debug log_format("FILTER", "Called add_flash_to_header")
    # only run this in case it's an Ajax request.
    return unless request.xhr?
    # add different flashes to header
    response.headers['X-Flash-Error'] = flash.now[:alert] unless flash.now[:alert].blank?
    response.headers['X-Flash-Notice'] = flash.now[:notice] unless flash.now[:notice].blank?
    flash.discard
  end

  # Renders a 404 page if an active record error occurs
  def error_rescue(exception = nil)
    return render_error_status(404, exception.message)
  end
  
  
  
  



  ##########################
  # NODE VALIDATITY CHECKS #
  ##########################

  # Checks the validity of the current page as well as the basic access rights
  def page_valid?
    # Page isn't valid
    return render_error_status(404, "No Page Found") if @requested_page.nil?
    # Page not displayed and not admin
    return render_error_status(404, "Shortcut: '#{@requested_page.shortcut}' not publicly displayed") if not @requested_page.displayed and not admin?
    return true
  end
  
  # Checks the validity of the current page as well as the basic access rights
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

