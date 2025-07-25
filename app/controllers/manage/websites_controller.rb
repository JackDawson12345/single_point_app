# app/controllers/manage/websites_controller.rb - Enhanced version
class Manage::WebsitesController < Manage::BaseController
  before_action :set_website, only: [:show, :edit, :update, :destroy, :preview]
  before_action :check_website_limit, only: [:new, :create]

  def index
    @website = current_user.website
    if @website
      redirect_to manage_website_path(@website)
    else
      redirect_to new_manage_website_path
    end
  end

  def show
    @pages = @website.website_pages.active.ordered
    @recent_updates = @website.website_pages.order(updated_at: :desc).limit(3)
  end

  def new
    @website = Website.new
    @themes = Theme.active.order(:name)
  end

  def create
    @website = current_user.build_website(website_params)

    if @website.save
      redirect_to manage_website_path(@website),
                  notice: 'Website created successfully! Start customizing your pages.'
    else
      @themes = Theme.active.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @themes = Theme.active.order(:name)
  end

  def update
    if @website.update(website_params)
      redirect_to manage_website_path(@website), notice: 'Website updated successfully!'
    else
      @themes = Theme.active.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @website.destroy
    redirect_to manage_root_path, notice: 'Website deleted successfully.'
  end

  def preview
    @page_type = params[:page] || 'home'
    @page = @website.website_pages.find_by(page_type: @page_type)

    unless @page
      @page = @website.website_pages.active.first
      @page_type = @page&.page_type || 'home'
    end

    render layout: 'website_preview'
  end

  def customize
    @website = current_user.website
    redirect_to new_manage_website_path unless @website

    @customizations = @website.customizations || {}
    @css_variables = @website.theme.css_variables || {}
  end

  def update_customizations
    @website = current_user.website

    if @website.update(customizations: customization_params)
      respond_to do |format|
        format.html { redirect_to customize_manage_websites_path, notice: 'Customizations saved successfully!' }
        format.json { render json: { status: 'success', message: 'Customizations saved!' } }
      end
    else
      @customizations = @website.customizations || {}
      @css_variables = @website.theme.css_variables || {}
      respond_to do |format|
        format.html { render :customize, status: :unprocessable_entity }
        format.json { render json: { status: 'error', errors: @website.errors } }
      end
    end
  end

  def publish
    @website = current_user.website

    if @website.update(published: !@website.published?)
      status = @website.published? ? 'published' : 'unpublished'
      redirect_to manage_website_path(@website), notice: "Website #{status} successfully!"
    else
      redirect_to manage_website_path(@website), alert: 'Failed to update website status.'
    end
  end

  def duplicate_theme
    @website = current_user.website
    new_theme_id = params[:theme_id]

    if new_theme_id.present? && Theme.active.exists?(new_theme_id)
      @website.update(theme_id: new_theme_id, customizations: {})
      redirect_to customize_manage_websites_path,
                  notice: 'Theme changed successfully! Customize your new theme below.'
    else
      redirect_to manage_website_path(@website), alert: 'Invalid theme selected.'
    end
  end

  private

  def set_website
    @website = current_user.website
    redirect_to new_manage_website_path unless @website
  end

  def check_website_limit
    if current_user.has_website?
      redirect_to manage_website_path(current_user.website),
                  alert: 'You can only create one website per account.'
    end
  end

  def website_params
    params.require(:website).permit(
      :site_name, :theme_id, :published,
      page_content: {},
      customizations: {}
    )
  end

  def customization_params
    params.require(:customizations).permit!.to_h
  end
end