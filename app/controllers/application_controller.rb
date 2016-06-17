class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :flash_class
  before_filter :require_login

  private
  def require_login
    unless current_user
      redirect_to '/'
    end
  end

#  def check_id (level, cid, id=0)
#      #Check if cid belongs to user
#      #Check if id belongs to user
#          #Either term/:tid/course/:cid
#          #or term/:tid
#    case level
#        when "grade"
#
#        when "subject"
#        else
#            return false
#    end
 # end
  #end

  def flash_class(level)
      #Switch statement doesn't seem to work
      if level == 'notice'
          "alert alert-info"
      elsif level == 'success'
            "alert alert-success"
      elsif level == 'danger'
            "alert alert-danger"
        elsif level == 'warning'
            "alert alert-warning"
        else
            "alert alert-waning"
    end
  end

  def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
