require "test_helper"

class FolderTest < ActiveSupport::TestCase
  test "name is required" do
    assert_raises(ActiveRecord::NotNullViolation) { folders(:main).update!(name: nil) }
  end
end
