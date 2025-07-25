class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # admin is a boolean field - true for admin, false for regular user
end
