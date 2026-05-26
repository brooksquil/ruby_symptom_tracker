class User < ApplicationRecord
  has_secure_password
  validates :email_address, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8, maximum: 72 }, allow_nil: true
  validates :password_confirmation, presence: true, if: -> { password.present? }
  has_many :sessions, dependent: :destroy
  has_many :symptoms, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
