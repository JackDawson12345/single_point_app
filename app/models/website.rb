# app/models/website.rb
class Website < ApplicationRecord
  belongs_to :user
  belongs_to :theme
  has_many :website_pages, dependent: :destroy

  validates :site_name, presence: true
  validates :domain_slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9\-]+\z/ }
  validates :user_id, uniqueness: true # One website per user

  before_validation :generate_domain_slug, if: -> { domain_slug.blank? }
  after_create :create_default_pages

  scope :published, -> { where(published: true) }

  def preview_url
    Rails.application.routes.url_helpers.preview_website_url(
      slug: domain_slug,
      subdomain: 'manage',
      host: Rails.application.config.action_mailer.default_url_options[:host]
    )
  end

  def page_content_for(page_type)
    page_content&.dig(page_type.to_s) || {}
  end

  def customizations_for_css
    return {} unless customizations

    # Merge theme defaults with user customizations
    theme.default_css_variables.merge(customizations)
  end

  private

  def generate_domain_slug
    base_slug = site_name.parameterize
    counter = 1
    slug = base_slug

    while Website.exists?(domain_slug: slug)
      slug = "#{base_slug}-#{counter}"
      counter += 1
    end

    self.domain_slug = slug
  end

  def create_default_pages
    %w[home about services contact].each_with_index do |page_type, index|
      website_pages.create!(
        page_type: page_type,
        title: page_type.humanize,
        active: true,
        sort_order: index
      )
    end
  end
end