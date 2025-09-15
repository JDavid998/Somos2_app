class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :ensure_admin, unless: :skip_admin_check?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role])
  end

  def after_sign_in_path_for(resource)
    if resource.admin?
      dashboard_path
    else
      root_path
    end
  end

  private

  def ensure_admin
    redirect_to root_path unless current_user&.admin?
  end

  def skip_admin_check?
    devise_controller? || 
    (controller_name == 'home' && action_name == 'index')
  end
end