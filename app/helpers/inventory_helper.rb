module InventoryHelper
  # Collects and Returns all the parameters for the URL that are not Rails specific and saves them in @parameters
  def inventory_search_parameters
    unless @parameters
      @parameters = params
      @parameters.delete('action')
      @parameters.delete('controller')
      @parameters.delete('utf8')
      @parameters.delete('commit')
      @parameters.delete('sort')
      @parameters.delete('direction')
      @parameters.delete('searchSubmit')
    end
    @parameters
  end

  # Returns the html string of breadcrumb search parameters
  def inventory_search_breadcrumbs
    breadcrumb_string = (parsed_inventory_search_breadcrumb_array.collect {|value| " &gt;<a href='#'>#{html_escape(value)}</a>"}).to_s
    breadcrumb_string
  end

  # Returns a concatonated and breadcrumb friendly array of values
  # TODO Implement further
  def parsed_inventory_search_breadcrumb_array
    params_array = inventory_search_parameters
    params_array.values.delete_if {|x| x.blank? }
  end
end

