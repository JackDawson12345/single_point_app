# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_subdomain_access
  before_action :handle_main_domain_redirect

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:admin])
    devise_parameter_sanitizer.permit(:account_update, keys: [:admin])
  end

  def check_subdomain_access
    case request.subdomain
    when 'manage'
      redirect_to root_url(subdomain: ''), allow_other_host: true if current_user&.admin?
    when 'admin'
      redirect_to root_url(subdomain: ''), allow_other_host: true unless current_user&.admin?
    end
  end

  # Handle redirects from main domain after login
  def handle_main_domain_redirect
    return unless user_signed_in? && request.subdomain.blank?

    if cookies[:just_logged_in] == 'true'
      cookies.delete :just_logged_in, domain: :all

      Rails.logger.info "Redirecting user #{current_user.email} (admin: #{current_user.admin?})"

      if current_user.admin?
        Rails.logger.info "Redirecting to admin subdomain"
        # Force a full page redirect, not a Turbo redirect
        redirect_to admin_root_url(subdomain: 'admin'), allow_other_host: true, status: :see_other
      else
        Rails.logger.info "Redirecting to manage subdomain"
        # Force a full page redirect, not a Turbo redirect
        redirect_to manage_root_url(subdomain: 'manage'), allow_other_host: true, status: :see_other
      end
    end
  end

  # Override Devise's after_sign_in_path_for
  def after_sign_in_path_for(resource)
    if request.subdomain.blank?
      cookies[:just_logged_in] = {
        value: 'true',
        domain: :all,
        expires: 1.minute.from_now
      }
      root_path
    else
      stored_location_for(resource) ||
        (resource.admin? ? admin_root_path : manage_root_path)
    end
  end

  # Override Devise's after_sign_up_path_for
  def after_sign_up_path_for(resource)
    if request.subdomain.blank?
      cookies[:just_logged_in] = {
        value: 'true',
        domain: :all,
        expires: 1.minute.from_now
      }
      root_path
    else
      if resource.admin?
        redirect_to admin_root_url(subdomain: 'admin'), allow_other_host: true
      else
        redirect_to manage_root_url(subdomain: 'manage'), allow_other_host: true
      end
    end
  end
end