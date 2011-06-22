module LoggingHelper 
  
  def log_format(error_type='CODE',msg="")
    log_category = LOG_CATEGORY.include?(error_type) ? error_type : LOG_CATEGORY[0]
    return ("**************** #{log_category} ****************\n" + 
            msg.inspect + "\n" +
            "*************** END #{log_category} *****************").to_s
  end
  
  def admin_request_error(msg="There was an error in your request", error_type='DB')
    logger.error log_format(error_type, msg)
    flash[:error] = msg
  end
    
end
