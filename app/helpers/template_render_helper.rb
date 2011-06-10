module TemplateRenderHelper
  ################### Admin Helpers #####################

  # Anything passed into an <%= admin_area do %> ... <% end %> block in an .erb file will get surrounded by <div class="admin"></div>
  def admin_wrapper(&block)
    if admin?
      content_tag(:div, :class => "admin clearfix", &block)
    else
      content_tag(:div, &block)
    end
  end

  def admin_area(&block)
    content_tag(:div, :class => "admin", &block) if admin?
  end

  def admin_controls_area(&block)
    content_tag(:span, :class => "controls", &block) if admin?
  end

  def get_elem_link_to_action(element, action)
    { :controller => "admin/page_elems/#{element.elem_type.tableize}", :action => action, :id => element.elem, :shortcut => @page.shortcut }
  end

  ##########################################################

  


  # Returns the HTML for displaying an Item column name
  def item_tag_for( model_name, column_name, value=nil)
    return '' if value.nil?
    return content_tag(:p, :id => model_name + '-' + column_name) do
      raw(
        content_tag(:span, column_name.humanize.capitalize, :class => 'attr-title') +
          content_tag(:span, value, :class => "attr-value" )
      )
    end
  end
end
