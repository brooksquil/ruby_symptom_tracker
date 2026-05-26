class User < ApplicationRecord
  has_secure_password
  validates :email_address, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8, maximum: 72 }
  validates :password_confirmation, presence: true, length: { minimum: 8, maximum: 72 }
  validates :password, confirmation: true, on: :create
  has_many :sessions, dependent: :destroy


  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
