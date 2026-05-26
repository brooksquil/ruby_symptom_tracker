class UserDiagnosis < ApplicationRecord
  belongs_to :user
  belongs_to :diagnosis

  validates :diagnosis_id, uniqueness: { scope: :user_id }
end