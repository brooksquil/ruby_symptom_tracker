require "test_helper"

class UserDiagnosisTest < ActiveSupport::TestCase
  test "user cannot select the same diagnosis twice" do
    diagnosis = Diagnosis.create!(name: "Migraine")
    users(:one).user_diagnoses.create!(diagnosis: diagnosis)

    user_diagnosis = users(:one).user_diagnoses.build(diagnosis: diagnosis)

    assert_not user_diagnosis.valid?
    assert_includes user_diagnosis.errors[:diagnosis_id], "has already been taken"
  end

  test "different users can select the same global diagnosis" do
    diagnosis = Diagnosis.create!(name: "Fibromyalgia")
    users(:one).user_diagnoses.create!(diagnosis: diagnosis)
    user_diagnosis = users(:two).user_diagnoses.build(diagnosis: diagnosis)

    assert user_diagnosis.valid?
  end
end
