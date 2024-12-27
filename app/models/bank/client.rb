class Bank::Client
  include Http, Token

  def initialize
    set_http_client
    set_token
  end
end
