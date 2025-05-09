require "test_helper"

class EntryTest < ActiveSupport::TestCase
  test "amount, currency are required" do
    assert_raises(ActiveRecord::NotNullViolation) { entries(:bus_ticket).update!(amount: nil) }
    assert_raises(ActiveRecord::NotNullViolation) { entries(:bus_ticket).update!(currency: nil) }
  end
end
