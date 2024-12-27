module Bank
  extend self

  def countries
    # https://gocardless.com/bank-account-data/coverage/
    #
    # `curl -sL https://docs.google.com/spreadsheets/d/1EZ5n7QDGaRIot5M86dwqd5UFSGEDTeTRzEq3D9uEDkM/export?format=csv`
    #   .then { CSV.parse it, headers: true }["Countries "]
    #   .filter { it&.length == 2 }
    #   .uniq
    #   .sort
    #   .join(" ")
    #   .then { puts "%w[#{it}]"}
    %w[AT BE BG CY CZ DE DK EE ES FI FR GB GR HR HU IE IS IT LT LU LV MT NL NO PL PT RO SE SI SK]
  end
end
