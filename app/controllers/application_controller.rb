class ApplicationController < ActionController::Base
  require 'csv'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_devise_permitted_parameters, if: :devise_controller?

  protected

  before_filter :set_branding, :set_mapKey

  def set_mapKey
    if current_user.present?
      @setting = Setting.find_by_account_id(current_user.account_id)
      
      key = @setting.google_api_key
      if key != nil
        @mapKey = key
      end

    end
  end

  def set_branding
    @branding = Branding.first
  end

  def configure_devise_permitted_parameters
    registration_params = [:email, :password, :password_confirmation]

    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password) }
#    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(registration_params << :stripe_customer_id) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(registration_params) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(registration_params) }
  end

  def after_sign_in_path_for(user)
    dashboard_path(user)
  end
end