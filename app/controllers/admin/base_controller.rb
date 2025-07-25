# app/controllers/admin/base_controller.rb
class Admin::BaseController < ApplicationController
  before_action :ensure_admin_access

  private

  def ensure_admin_access
    redirect_to root_url(subdomain: '') unless current_user&.admin?
  end
end