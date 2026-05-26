require "test_helper"

class UserDiagnosesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @other_user = users(:two)
    sign_in_as(@user)
  end

  test "create adds a diagnosis to current user's list" do
    diagnosis = Diagnosis.create!(name: "Migraine")

    assert_difference -> { @user.user_diagnoses.count }, 1 do
      post user_diagnoses_path, params: {
        user_diagnosis: {
          diagnosis_id: diagnosis.id
        }
      }
    end

    assert_redirected_to diagnoses_path
    assert_equal "Migraine added to your diagnoses.", flash[:notice]
  end

  test "create rejects duplicate selected diagnosis" do
    diagnosis = Diagnosis.create!(name: "Fibromyalgia")
    @user.user_diagnoses.create!(diagnosis: diagnosis)

    assert_no_difference -> { @user.user_diagnoses.count } do
      post user_diagnoses_path, params: {
        user_diagnosis: {
          diagnosis_id: diagnosis.id
        }
      }
    end

    assert_redirected_to diagnoses_path
    assert_match "already exists", flash[:alert]
  end

  test "edit cannot access another user's selected diagnosis" do
    diagnosis = Diagnosis.create!(name: "POTS")
    other_user_diagnosis = @other_user.user_diagnoses.create!(diagnosis: diagnosis)

    get edit_user_diagnosis_path(other_user_diagnosis)

    assert_response :not_found
  end

  test "edit is accessible for current user's selected diagnosis" do
    diagnosis = Diagnosis.create!(name: "Endometriosis")
    user_diagnosis = @user.user_diagnoses.create!(diagnosis: diagnosis)

    get edit_user_diagnosis_path(user_diagnosis)

    assert_response :success
  end

  test "update changes diagnosis details" do
    diagnosis = Diagnosis.create!(name: "MCAS")
    user_diagnosis = @user.user_diagnoses.create!(diagnosis: diagnosis)

    patch user_diagnosis_path(user_diagnosis), params: {
      user_diagnosis: {
        diagnosed_on: "2024-01-02",
        notes: "Diagnosed by specialist"
      }
    }

    assert_redirected_to diagnoses_path
    assert_equal Date.new(2024, 1, 2), user_diagnosis.reload.diagnosed_on
    assert_equal "Diagnosed by specialist", user_diagnosis.notes
  end

  test "destroy removes selected diagnosis from current user's list" do
    diagnosis = Diagnosis.create!(name: "Asthma")
    user_diagnosis = @user.user_diagnoses.create!(diagnosis: diagnosis)

    assert_difference -> { @user.user_diagnoses.count }, -1 do
      delete user_diagnosis_path(user_diagnosis)
    end

    assert_redirected_to diagnoses_path
  end
end
