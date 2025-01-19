require "test_helper"

class PerspectiveDatabasesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get perspective_databases_show_url
    assert_response :success
  end
end
