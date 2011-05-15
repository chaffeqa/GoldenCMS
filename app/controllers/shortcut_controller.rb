class ShortcutController < ApplicationController
  before_filter :home_page, :only => :home
  before_filter :get_node, :except => :error
  before_filter :check_route, :except => :error
  #caches_action :route , :unless => Proc.new { |c| admin? }, :cache_path => Proc.new { |c|c.send(:shortcut_path, @node.id)}

  # Routing method for all shortcut_path routes, looks for a Node for the current
  # request and renders or redirects appropriatly
  def route
    render_with_cache('node-page::'+request.fullpath+'::'+@node.cache_key) { render("#{@node.template_path}", :layout => @node.layout) }
  end

  # Action for the root_path route.  Sets the current node (@node) = @home_node so
  # the current sites home page is displayed
  def home
    render_with_cache('node-page::'+request.fullpath+'::'+@node.cache_key) { render("#{@node.template_path}", :layout => @node.layout) }
  end

  # Action for displaying an error.  Accepts both a :shortcut and :message param
  def error
    status = [500,404,422].include?(params[:status]) ? params[:status] : 500
    @message = params[:message] || ''
    @shortcut = params[:shortcut] || ''
    unless @shortcut.blank? and @message.blank?
      logger.error "REQUEST **************** Error Action Called - Status: #{status}, Shortcut: #{@shortcut}, Message: #{@message} **************** "
      @similar_nodes = Node.displayed.similar_shortcuts(@shortcut)
      render('error_page/error', :status => status)
    else
      logger.error "REQUEST **************** Error Action Called - Status: #{status}, No Shortcut, no Message **************** "
      render_error_status(status)
    end
  end





  private

  # Sets the current node to the home_node
  def home_page
    @node = @current_site.node
    return !@node.nil?
  end

  # Performs specific @node route checks and redirects
  def check_route
    # Page exists?
    if @node and @node.has_page? and @node.page_type=='Item' and @node.page.has_better_url?
      # Redirect to This Item's first category listing if it exists. To ensure the menus display correctly
      redirect_to shortcut_path(:shortcut => @node.page.better_url)
      return false
    end
  end

end

