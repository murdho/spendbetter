require "test_helper"

class DatabasesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get databases_show_url
    assert_response :success
  end
end
