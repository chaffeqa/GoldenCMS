module SessionSearchHelper
  #######################
  # Search Helpers
  #######################

  def session_sortable(column, title)
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "ASC") ? "DESC" : "ASC"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end



  def session_sort_column
    @sort ||= session[:user_filters][:sort] || ''
  end

  def session_sort_direction
    @direction ||= session[:user_filters][:direction] || ''
    "ASC DESC".include?(@direction) ? @direction : "ASC"
  end

  def session_update_selected_user_ids(add='',remove='')
    @selected_user_ids ||= session[:user_filters][:user_ids].blank? ? [] : session[:user_filters][:user_ids]
    @selected_user_ids.uniq!
    session[:user_filters].delete_if {|k,v|  v.class != String } # remove all non-string params
    session[:user_filters][:user_ids] = @selected_user_ids
  end

  def session_pagination_filter
    @per_page ||= session[:user_filters][:per_page] || 10
    @requested_page ||= session[:user_filters][:page] || '1'
  end
end

