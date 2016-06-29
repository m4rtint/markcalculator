class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :flash_class, :check_id
  before_filter :require_login

  private
  def require_login
    unless current_user
      redirect_to '/'
    end
  end

  def check_id (cid, id=0)
#          #Either term/:tid/course/:cid
#          #or term/:tid
    if id != 0 && !Grade.where(:id => id, :subject_id => cid).present?
        return true
    end

    subject = Subject.where(:id => cid).first

    if !subject.present? || !Term.where(:user_id => current_user.id, :id => subject.term_id).present?
        return true
    end

    return false
  end


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
