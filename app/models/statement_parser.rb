class StatementParser
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
      .process(file, csv_parser_options)
      .map { statement_format.normalize_transaction(_1) }
  end

  def csv_parser_options
    {
      convert_values_to_numeric: false,
      keep_original_headers: true,
      key_mapping: key_mapping,
      remove_empty_values: false,
      remove_unmapped_keys: true
    }
  end

  def key_mapping
    statement_format.column_mapping.compact.invert
  end
end
