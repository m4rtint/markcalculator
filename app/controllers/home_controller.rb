class HomeController < ApplicationController
 skip_before_filter :require_login
  def index
      if current_user
          redirect_to '/term'
      end
  end

end
