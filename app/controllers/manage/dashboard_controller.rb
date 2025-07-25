# app/controllers/manage/dashboard_controller.rb
class Manage::DashboardController < ApplicationController
  before_action :ensure_non_admin_access

  def index
    @users_count = User.count
    @recent_users = User.order(created_at: :desc).limit(5)
  end

  private

  def ensure_non_admin_access
    redirect_to root_url(subdomain: ''), allow_other_host: true if current_user&.admin?
  end
end