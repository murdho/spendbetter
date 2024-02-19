module StatementFormat::Parser
  def parse(file)
    statement_parser.parse(file) => { filename:, transactions: }
    [ filename, transactions ]
  end

  private

  def statement_parser
    StatementParser.new(self)
  end
end
