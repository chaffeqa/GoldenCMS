# Form Helpers
module FormHelper
  
  #############################
  # Dynamic has_many generation
  #############################
  
  def remove_child_link(name, f)
    link_to(name, "javascript:void(0)", :class => "remove_child")
  end

  def add_child_link(name, association)
    link_to(name, "javascript:void(0)", :class => "add_child", :"data-association" => association)
  end

  def new_child_fields_template(form_builder, association, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(association).klass.new
    options[:partial] ||= association.to_s.singularize
    options[:form_builder_local] ||= :f
    content_tag(:div, :id => "#{association}_fields_template", :style => "display: none") do
      form_builder.fields_for(association, options[:object], :child_index => "new_#{association}") do |f|
        render(:partial => options[:partial], :locals => {options[:form_builder_local] => f})
      end
    end
  end
  
  
  
  ##################
  # <Select> helpers
  ##################
  
  
  # Returns an array representing this site's page tree.  Uses the page#menu_name as the displayed page attribute.
  # Different levels are rendered using a "--" string to indent.
  # Ex. [..., ['Page2',2], ['--Page3', 3], ...]
  def select_page_tree_from_site(site)
    site.site_tree_select
  end
  
  
  # Create the array of options to populate a <select> element for setting the Page.layout_name
  def select_page_layout_name
    TEMPLATES.collect {|key,value| [value["human_name"], key] }
  end
  

  def color_select
    [
      'Red',
      'Blue',
      'Green',
      'Yellow',
      'Purple',
      'Orange'
    ]
  end
end
