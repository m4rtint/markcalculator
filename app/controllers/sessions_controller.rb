class SessionsController < ApplicationController
     skip_before_filter :require_login
  def create
      auth = request.env["omniauth.auth"]
      session[:omniauth] = auth.except('extra')
      user = User.from_omniauth(env["omniauth.auth"])
      session[:user_id] = user.id
      redirect_to root_path
  end

  def destroy
      session[:user_id] = nil
      session[:omniauth] = nil
      redirect_to root_path
  end
end
