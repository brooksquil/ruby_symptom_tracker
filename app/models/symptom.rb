class Symptom < ApplicationRecord
  belongs_to :user, optional: true
  has_many :symptom_entries, dependent: :restrict_with_error

  before_validation :normalize_name

  validates :name, presence: true
  validates :normalized_name, presence: true
  validates :normalized_name, uniqueness: {
    scope: :user_id,
    case_sensitive: false,
    message: "already exists"
  }

  validate :custom_symptom_does_not_duplicate_global_symptom

  scope :global, -> { where(user_id: nil) }
  scope :custom, -> { where.not(user_id: nil) }
  scope :for_user, ->(user) { where(user_id: [nil, user.id]) }

  def global?
    user_id.nil?
  end

  def custom?
    user_id.present?
  end

  private

  def normalize_name
    self.name = name&.strip
    self.normalized_name = name&.strip&.downcase
  end

  def custom_symptom_does_not_duplicate_global_symptom
    return if user_id.blank? || normalized_name.blank?

    if Symptom.global.where(normalized_name: normalized_name).where.not(id: id).exists?
      errors.add(:name, "already exists in the common symptom list")
    end
  end
end