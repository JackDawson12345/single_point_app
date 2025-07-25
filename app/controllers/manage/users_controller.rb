# app/controllers/manage/users_controller.rb
class Manage::UsersController < Manage::BaseController
  before_action :set_user, only: [:show, :edit, :update]

  def index
    @users = User.all.order(:email)
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to manage_user_path(@user), notice: 'User updated successfully.'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :admin)
  end
end