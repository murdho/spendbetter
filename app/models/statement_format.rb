class StatementFormat < ApplicationRecord
  include Parser

  def column_mapping
    %i[date amount currency party description].to_h { [ _1, self["#{_1}_col"] ] }
  end
end
