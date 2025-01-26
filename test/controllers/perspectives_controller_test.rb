require "test_helper"

class PerspectivesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @perspective = perspectives(:latest_entries)
  end

  test "should get index" do
    get perspectives_url
    assert_response :success
  end

  test "should create perspective" do
    assert_difference("Perspective.count") do
      post perspectives_url, params: { perspective: { name: @perspective.name, pinned: @perspective.pinned, query: @perspective.query } }
    end

    assert_redirected_to perspectives_url(perspective: Perspective.last)
  end

  test "should update perspective" do
    patch perspective_url(@perspective), params: { perspective: { name: @perspective.name, pinned: @perspective.pinned, query: @perspective.query } }
    assert_redirected_to perspectives_url(perspective: @perspective)
  end

  test "should destroy perspective" do
    assert_difference("Perspective.count", -1) do
      delete perspective_url(@perspective)
    end

    assert_redirected_to perspectives_url
  end
end
