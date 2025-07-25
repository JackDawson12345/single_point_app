class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :website, dependent: :destroy

  def can_create_website?
    !admin? && website.nil?
  end

  def has_website?
    website.present?
  end
end