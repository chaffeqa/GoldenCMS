module ViewMacros 
  
  def create_test_site
    view.stub(:current_site) {create(:site)}
  end
  
  def log_in_admin
    view.stub(:admin?) { true }
    stub_template "partials/_admin_bar.html.haml" => 'admin_bar partial'
  end

  # Returns the file names in the "layouts/partials directory
  def layout_partials
    Dir.glob(Rails.root+"app/views/layouts/partials/*").collect {|path| 
      File.basename(path,".html.erb") 
    }
  end
end
