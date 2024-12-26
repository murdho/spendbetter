require "test_helper"

class FolderTest < ActiveSupport::TestCase
  test "name is required" do
    assert_raises ActiveRecord::NotNullViolation do
      Folder.create!(name: nil)
    end

    assert_nothing_raised do
      Folder.create!(name: "Folder #{rand}")
    end
  end
end
