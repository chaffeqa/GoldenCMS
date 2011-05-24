module LoggingHelper 
  
  def log_format(cat, msg="")
    log_category = LOG_CATEGORY.include?(cat) ? cat : LOG_CATEGORY[0]
    return ("**************** #{log_category} ****************\n" + 
            msg.inspect + "\n" +
            "*************** END #{log_category} *****************").to_s
  end
end
