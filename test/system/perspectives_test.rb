require "application_system_test_case"

class PerspectivesTest < ApplicationSystemTestCase
  setup do
    @perspective = perspectives(:latest_entries)
  end

  test "visiting the index" do
    visit perspectives_url
    assert_selector "h1", text: "spendbetter"
  end

  test "should create perspective" do
    visit perspectives_url

    name = SecureRandom.uuid
    fill_in "Name", with: name
    fill_in "Query", with: @perspective.query
    click_on "Save & Run"

    assert_text name
  end

  test "should update Perspective" do
    visit perspectives_url
    click_on @perspective.name, match: :first

    name = SecureRandom.uuid
    fill_in "Name", with: name
    fill_in "Query", with: @perspective.query
    click_on "Save & Run"

    assert_text name
  end

  test "should destroy Perspective" do
    visit perspectives_url
    click_on @perspective.name, match: :first

    accept_confirm do
      click_on "Delete", match: :first
    end

    assert_no_text @perspective.name
  end
end
