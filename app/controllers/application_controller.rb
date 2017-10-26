class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :wallet_address, :balance])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :wallet_address, :jackpot_id, :balance])
  end
  
  before_filter :set_current_user

  def set_current_user
    User.current_user = current_user
  end

  def time_left
    
  end

end
