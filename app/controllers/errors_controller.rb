class ErrorsController < ApplicationController

  # Action for displaying an error.  Accepts both a :shortcut and :message param
  def error
    status = [500,404,422].include?(params[:status]) ? params[:status] : 500
    @message = params[:message] || ''
    @shortcut = params[:shortcut] || ''
    unless @shortcut.blank? and @message.blank?
      logger.error log_format("REQUEST","Error Action Called - Status: #{status}, Shortcut: #{@shortcut}, Message: #{@message}")
      @similar_nodes = Node.displayed.similar_shortcuts(@shortcut)
      render('errors/error', :status => status)
    else
      logger.error log_format("REQUEST","Error Action Called - Status: #{status}, No Shortcut, no Message")
      render_error_status(status)
    end
  end

end

