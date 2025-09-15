class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :ensure_admin
  
  def index
    
    if user_signed_in? && current_user.admin?
      redirect_to dashboard_path
    end
  end
end
