class Theme < ApplicationRecord
  has_many :websites, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  validates :template_files, :css_variables, presence: true

  scope :active, -> { where(active: true) }

  def template_for_page(page_type)
    template_files&.dig(page_type.to_s)
  end

  def default_css_variables
    css_variables || {}
  end
end