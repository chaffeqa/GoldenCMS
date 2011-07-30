module LoggingHelper 
  
  # Creates the application log formatted string.
  # @error_type String of the log category
  # @msg String of the message to be logged inside the Log Category block
  # @returns String of properly formated log output
  def log_format(error_type='CODE',msg="")
    log_category = LOG_CATEGORY.include?(error_type) ? error_type : LOG_CATEGORY[0]
    return ("**************** #{log_category} ****************\n" + 
            msg.inspect + "\n" +
            "*************** END #{log_category} *****************").to_s
  end
  
  # Idea: for complicated log msgs, I dont want to perform those operations if the log lvl 
  # isnt debug.
  # NOTE: implement?
  def log_debug(error_type="CODE")
    logger.debug log_format(error_type, yield) if Rails.env == :development
  end
  
  # Logs a request error and sets the flash Error.  Used when an administrator is logged in and 
  # we want to display a nice flash error
  # @msg String the error that happened
  # @error_type String type of error that was triggered
  def admin_request_error(msg="There was an error in your request", error_type='DB')
    logger.error log_format(error_type, msg)
    flash[:error] = msg
  end
    
end
