class Perspective < ApplicationRecord
  class << self
    def database(&)
      if block_given?
        Perspective::Database.then(&)
      else
        Perspective::Database
      end
    end
  end
end
