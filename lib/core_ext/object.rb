class Object
  AssertionFailed = Class.new(StandardError)

  def assert(test, message = nil)
    unless test
      message ||= "Expected #{test.inspect} to be truthy."
      raise AssertionFailed, message
    end
  end
end
