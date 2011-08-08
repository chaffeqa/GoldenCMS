module ViewMacros 

  # Returns the file names in the "layouts/partials directory
  def layout_partials
    Dir.glob(Rails.root+"app/views/layouts/partials/*").collect {|path| 
      File.basename(path,".html.erb") 
    }
  end
end
