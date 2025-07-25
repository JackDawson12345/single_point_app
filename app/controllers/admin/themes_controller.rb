# app/controllers/admin/themes_controller.rb
class Admin::ThemesController < Admin::BaseController
  before_action :set_theme, only: [:show, :edit, :update, :destroy]

  def index
    @themes = Theme.all.order(:name)
  end

  def show
  end

  def new
    @theme = Theme.new
  end

  def create
    @theme = Theme.new(theme_params)

    if @theme.save
      redirect_to admin_theme_path(@theme), notice: 'Theme created successfully.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @theme.update(theme_params)
      redirect_to admin_theme_path(@theme), notice: 'Theme updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    if @theme.websites.exists?
      redirect_to admin_themes_path, alert: 'Cannot delete theme that is being used by websites.'
    else
      @theme.destroy
      redirect_to admin_themes_path, notice: 'Theme deleted successfully.'
    end
  end

  private

  def set_theme
    @theme = Theme.find(params[:id])
  end

  def theme_params
    params.require(:theme).permit(
      :name, :description, :preview_image, :active,
      template_files: {},
      css_variables: {}
    )
  end
end