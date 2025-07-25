# app/controllers/manage/website_pages_controller.rb
class Manage::WebsitePagesController < Manage::BaseController
  before_action :set_website
  before_action :set_page, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update
    if @page.update(page_params)
      redirect_to website_path(@website),
                  notice: "#{@page.page_type.humanize} page updated successfully!"
    else
      render :edit
    end
  end

  private

  def set_website
    @website = current_user.website
    redirect_to new_website_path unless @website
  end

  def set_page
    @page = @website.website_pages.find(params[:id])
  end

  def page_params
    params.require(:website_page).permit(
      :title, :content, :active,
      page_data: {}
    )
  end
end