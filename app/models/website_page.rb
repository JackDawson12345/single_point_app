# app/models/website_page.rb
class WebsitePage < ApplicationRecord
  belongs_to :website

  validates :page_type, presence: true, inclusion: { in: %w[home about services contact] }
  validates :page_type, uniqueness: { scope: :website_id }

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:sort_order) }

  def default_content
    case page_type
    when 'home'
      {
        hero_title: 'Welcome to Our Website',
        hero_subtitle: 'Your success is our mission',
        hero_cta: 'Get Started',
        features: [
          { title: 'Feature 1', description: 'Amazing feature description' },
          { title: 'Feature 2', description: 'Another great feature' },
          { title: 'Feature 3', description: 'One more awesome feature' }
        ]
      }
    when 'about'
      {
        title: 'About Us',
        content: 'Tell your story here. Share what makes your business unique.',
        team_members: []
      }
    when 'services'
      {
        title: 'Our Services',
        services: [
          { name: 'Service 1', description: 'Service description', price: '$99' },
          { name: 'Service 2', description: 'Service description', price: '$199' }
        ]
      }
    when 'contact'
      {
        title: 'Contact Us',
        address: '123 Main St, City, State 12345',
        phone: '(555) 123-4567',
        email: 'info@yoursite.com',
        hours: 'Mon-Fri 9am-5pm'
      }
    else
      {}
    end
  end

  def merged_content
    default_content.deep_merge(page_data || {})
  end
end