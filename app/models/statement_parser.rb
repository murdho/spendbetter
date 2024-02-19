class StatementParser
  include TransactionNormalizer

  def initialize(statement_format)
    @statement_format = statement_format
  end

  def parse(file)
    { filename: filename(file), transactions: transactions(file) }
  end

  private

  attr_reader :statement_format

  def filename(file)
    file.try(:original_filename) || File.basename(file)
  end

  def transactions(file)
    SmarterCSV
      .process(file, { keep_original_headers: true, key_mapping: key_mapping, remove_unmapped_keys: true })
      .map { normalize_transaction(_1) }
  end

  def key_mapping
    statement_format.column_mapping.compact.invert
  end
end
