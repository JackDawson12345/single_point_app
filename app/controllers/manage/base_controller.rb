# app/controllers/manage/base_controller.rb
class Manage::BaseController < ApplicationController
  before_action :ensure_non_admin_access

  private

  def ensure_non_admin_access
    # Only non-admin users can access manage subdomain
    redirect_to root_url(subdomain: '') if current_user&.admin?
  end
end