class Bank::Account
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def info
    @info ||= client.account_info(id)
  end

  def balances
    @balances ||= client.account_balances(id)
  end

  def details
    @details ||= client.account_details(id)
  end

  def transactions(from: nil, to: nil)
    if from || to
      client.account_transactions(id, from:, to:)
    else
      @transactions ||= client.account_transactions(id, from:, to:)
    end
  end

  private
    def client
      @client ||= Bank::Client.new
    end
end
