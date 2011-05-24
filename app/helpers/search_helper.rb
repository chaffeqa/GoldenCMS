module SearchHelper
  #######################
  # Search Helpers
  #######################



  def low_cost
    @min_price ||= @search_params[:cost_range].blank? ? '' : @search_params[:cost_range].split('-')[0]
  end

  def high_cost
    @max_price ||= @search_params[:cost_range].blank? ? '' : @search_params[:cost_range].split('-')[1]
  end

  def sort_column
    @sort ||= @search_params[:sort] || ''
  end

  def sort_direction
    @direction ||= @search_params[:direction] || ''
    "ASC DESC".include?(@direction) ? @direction : "ASC"
  end  

  # Retrieves the pagination info from the @search_params.
  # NOTE the format for the params are as follows:
  #   @per_page = any params key that matches /^per_page/ regexp
  #   @page = any params key that matches /^page/ regexp
  def pagination
    @per_page ||= (@search_params.select {|k,v| k =~ /^per_page/}.flatten.last || 10).to_i
    @page ||= (@search_params.select {|k,v| k =~ /^page/}.flatten.last || 1).to_i
    logger.debug log_format("CODE","page: #{@page.inspect}, @per_page: #{@per_page.inspect}")
  end
  
  # Retrieves the pagination "page" attribute for a given element (passed in as a prefix uniq identifyer)
  def get_page(prefix="")
    (@search_params[prefix + "page"] || 1).to_i
  end
  
  # Retrieves the pagination "per_page" attribute for a given element (passed in as a prefix uniq identifyer)
  def get_per_page(prefix="")
    (@search_params[prefix + "per_page"] || 10).to_i
  end
  
  # Collects and Returns all the parameters for the URL that are not Rails specific and saves them in @search_params
  def parse_search_params(params={})
    unless @search_params
      @search_params = params.clone()
      @search_params.delete('action')
      @search_params.delete('controller')
      @search_params.delete('utf8')
      @search_params.delete('commit')
      @search_params.delete('authenticity_token')
      @search_params.delete_if {|k,v| v.blank? or v.class != String or k =~ /_input$/ }
    end
    logger.debug "@search_params: " + @search_params.inspect
    sort_column; sort_direction; pagination; low_cost; high_cost
  end
  
  

  def sortable_td(column_name, content_or_options_with_block = nil, options = nil, escape = true, &block)
    class_option = {:class=>((@sort == column_name) ? "sorted" : "")}
    if block_given?
      options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
      options = options.nil? ? class_option : options.merge(class_option){|key, oldval, newval| newval + oldval}
      content_tag_string(:td, capture(&block), options, escape)
    else
      options = options.nil? ? class_option : options.merge(class_option){|key, oldval, newval| newval + oldval}
      content_tag_string(:td, content_or_options_with_block, options, escape)
    end
  end


  def sortable(column, title, addition_params=@search_params)
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "ASC") ? "DESC" : "ASC"
    link_to title, addition_params.merge({:sort => column, :direction => direction}), {:class => css_class}
  end
end

