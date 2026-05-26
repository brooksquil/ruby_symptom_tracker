require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "new is accessible without authentication" do
    get new_user_path

    assert_response :success
  end

  test "create with valid parameters redirects to sign in" do
    assert_difference "User.count", 1 do
      post users_path, params: {
        user: {
          email_address: "new-user@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end

    assert_redirected_to new_session_path
    assert_equal "User created successfully. Please sign in.", flash[:notice]
  end

  test "create with invalid parameters shows errors" do
    assert_no_difference "User.count" do
      post users_path, params: {
        user: {
          email_address: "",
          password: "password",
          password_confirmation: "different"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select "p", "We could not create your account:"
  end

  test "profile requires authentication" do
    get profile_path

    assert_redirected_to new_session_path
  end

  test "authenticated user can update time zone" do
    user = users(:one)
    sign_in_as(user)

    patch profile_path, params: {
      user: {
        time_zone: "Eastern Time (US & Canada)"
      }
    }

    assert_redirected_to profile_path
    assert_equal "Eastern Time (US & Canada)", user.reload.time_zone
  end
end
