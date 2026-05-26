require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "redirects unauthenticated users to sign in" do
    get dashboard_show_url

    assert_redirected_to new_session_path
  end

  test "authenticated user can see dashboard" do
    sign_in_as(users(:one))

    get dashboard_show_url

    assert_response :success
  end
end
