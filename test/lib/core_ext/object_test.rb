require "test_helper"

class CoreExt::ObjectTest < ActiveSupport::TestCase
  setup do
    @obj = Object.new
  end

  test "assert" do
    assert_nothing_raised do
      @obj.assert true, "something's afoot"
    end

    assert_raises AssertionFailed, match: /something's afoot/ do
      @obj.assert false, "something's afoot"
    end
  end
end
