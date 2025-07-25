# app/controllers/admin/dashboard_controller.rb
class Admin::DashboardController < Admin::BaseController
  def index
    @total_users = User.count
    @admin_users = User.where(admin: true).count
    @regular_users = User.where(admin: false).count
  end
end