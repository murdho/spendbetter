require "test_helper"

class PerspectiveDatabasesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get perspective_database_url
    assert_response :success
  end
end
