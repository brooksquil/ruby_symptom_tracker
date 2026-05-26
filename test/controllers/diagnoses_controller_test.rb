require "test_helper"

class DiagnosesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @other_user = users(:two)
    sign_in_as(@user)
  end

  test "index shows global, current user custom, and selected diagnoses" do
    global_diagnosis = Diagnosis.create!(name: "Migraine")
    custom_diagnosis = @user.diagnoses.create!(name: "My custom diagnosis")
    @user.user_diagnoses.create!(diagnosis: global_diagnosis, diagnosed_on: Date.current)
    @other_user.diagnoses.create!(name: "Other user diagnosis")

    get diagnoses_path

    assert_response :success
    assert_includes response.body, global_diagnosis.name
    assert_includes response.body, custom_diagnosis.name
    assert_not_includes response.body, "Other user diagnosis"
  end

  test "new is accessible" do
    get new_diagnosis_path

    assert_response :success
  end

  test "create adds custom diagnosis and selects it for current user" do
    assert_difference -> { @user.diagnoses.count }, 1 do
      assert_difference -> { @user.user_diagnoses.count }, 1 do
        post diagnoses_path, params: {
          diagnosis: {
            name: "Custom chronic condition"
          }
        }
      end
    end

    assert_redirected_to diagnoses_path
    assert_equal "Custom chronic condition added to your diagnoses.", flash[:notice]
  end

  test "create rejects custom diagnosis that duplicates global diagnosis" do
    Diagnosis.create!(name: "POTS")

    assert_no_difference -> { @user.diagnoses.count } do
      post diagnoses_path, params: {
        diagnosis: {
          name: "pots"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_match "already exists", response.body
  end

  test "edit cannot access another user's custom diagnosis" do
    other_diagnosis = @other_user.diagnoses.create!(name: "Private diagnosis")

    get edit_diagnosis_path(other_diagnosis)

    assert_response :not_found
  end

  test "update changes current user's custom diagnosis" do
    diagnosis = @user.diagnoses.create!(name: "Old name")

    patch diagnosis_path(diagnosis), params: {
      diagnosis: {
        name: "New name"
      }
    }

    assert_redirected_to diagnoses_path
    assert_equal "New name", diagnosis.reload.name
  end

  test "destroy removes current user's custom diagnosis and selection" do
    diagnosis = @user.diagnoses.create!(name: "Remove me")
    @user.user_diagnoses.create!(diagnosis: diagnosis)

    assert_difference -> { @user.diagnoses.count }, -1 do
      assert_difference -> { @user.user_diagnoses.count }, -1 do
        delete diagnosis_path(diagnosis)
      end
    end

    assert_redirected_to diagnoses_path
  end
end
