class Bank::Institution
  include Bank::Connection

  attr_reader :id, :name, :transaction_total_days, :max_access_valid_for_days

  class << self
    def find_by_country(country)
      connection
        .get("institutions/", { country: })
        .body
        .map { new **it }
    end

    def find(id)
      connection
        .get("institutions/#{id}/")
        .body
        .then { new **it }
    end
  end

  def initialize(id:, **attrs)
    @id = id
    @name = attrs[:name]
    @transaction_total_days = attrs[:transaction_total_days].to_i
    @max_access_valid_for_days = attrs[:max_access_valid_for_days].to_i
  end
end
