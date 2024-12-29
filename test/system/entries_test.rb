require "application_system_test_case"

class EntriesTest < ApplicationSystemTestCase
  setup do
    @entry = entries(:bus_ticket)
  end

  test "visiting the index" do
    visit entries_url
    assert_selector "h1", text: "Entries"
  end

  test "should create entry" do
    visit entries_url
    click_on "New entry"

    fill_in "Amount", with: @entry.amount
    fill_in "Currency", with: @entry.currency
    fill_in "Date", with: @entry.date
    fill_in "External", with: @entry.external_id
    fill_in "Folder", with: @entry.folder_id
    fill_in "Message", with: @entry.message
    fill_in "Party", with: @entry.party
    click_on "Create Entry"

    assert_text "Entry was successfully created"
    click_on "Back"
  end

  test "should update Entry" do
    visit entry_url(@entry)
    click_on "Edit this entry", match: :first

    fill_in "Amount", with: @entry.amount
    fill_in "Currency", with: @entry.currency
    fill_in "Date", with: @entry.date
    fill_in "External", with: @entry.external_id
    fill_in "Folder", with: @entry.folder_id
    fill_in "Message", with: @entry.message
    fill_in "Party", with: @entry.party
    click_on "Update Entry"

    assert_text "Entry was successfully updated"
    click_on "Back"
  end

  test "should destroy Entry" do
    visit entry_url(@entry)
    click_on "Destroy this entry", match: :first

    assert_text "Entry was successfully destroyed"
  end
end
