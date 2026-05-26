require "test_helper"

class SymptomsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @other_user = users(:two)
    sign_in_as(@user)
  end

  test "index shows global and current user symptoms" do
    Symptom.create!(name: "Fatigue")
    @user.symptoms.create!(name: "Personal symptom")
    @other_user.symptoms.create!(name: "Other user symptom")

    get symptoms_path

    assert_response :success
    assert_includes response.body, "Fatigue"
    assert_includes response.body, "Personal symptom"
    assert_not_includes response.body, "Other user symptom"
  end

  test "create adds a custom symptom for current user" do
    assert_difference -> { @user.symptoms.count }, 1 do
      post symptoms_path, params: {
        symptom: {
          name: "Custom tracking symptom"
        }
      }
    end

    assert_redirected_to symptoms_path
    assert_equal "Custom tracking symptom added to your symptoms.", flash[:notice]
  end

  test "create rejects symptom that duplicates global symptom" do
    Symptom.create!(name: "Brain fog")

    assert_no_difference -> { @user.symptoms.count } do
      post symptoms_path, params: {
        symptom: {
          name: "brain FOG"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_match "already exists", response.body
  end

  test "edit cannot access another user's symptom" do
    other_symptom = @other_user.symptoms.create!(name: "Private symptom")

    get edit_symptom_path(other_symptom)

    assert_response :not_found
  end

  test "update shows errors" do
    Symptom.create!(name: "Migraine")
    symptom = @user.symptoms.create!(name: "Head pressure")

    patch symptom_path(symptom), params: {
      symptom: {
        name: "migraine"
      }
    }

    assert_response :unprocessable_entity
    assert_match "We could not update this symptom:", response.body
  end
end
