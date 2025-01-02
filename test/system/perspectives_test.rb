require "application_system_test_case"

class PerspectivesTest < ApplicationSystemTestCase
  setup do
    @perspective = perspectives(:latest_entries)
  end

  test "visiting the index" do
    visit perspectives_url
    assert_selector "h1", text: "Perspectives"
  end

  test "should create perspective" do
    visit perspectives_url
    click_on "New perspective"

    fill_in "Name", with: @perspective.name
    fill_in "Query", with: @perspective.query
    click_on "Create Perspective"

    assert_text "Perspective was successfully created"
    # click_on "Back"
  end

  test "should update Perspective" do
    visit perspective_url(@perspective)
    click_on "Edit this perspective", match: :first

    fill_in "Name", with: @perspective.name
    fill_in "Query", with: @perspective.query
    click_on "Update Perspective"

    assert_text "Perspective was successfully updated"
    # click_on "Back"
  end

  test "should destroy Perspective" do
    skip
    visit perspective_url(@perspective)
    click_on "Destroy this perspective", match: :first

    assert_text "Perspective was successfully destroyed"
  end
end
