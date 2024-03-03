module Statement::FileImportable
  extend ActiveSupport::Concern

  class_methods do
    def import_from_file(file_and_attributes)
      statement = new(file_and_attributes.except(:file))
      statement.import_from_file(file_and_attributes.fetch(:file))
      statement
    end
  end

  def import_from_file(file)
    filename, transactions = parse_file(file)

    transaction do
      update!(filename: filename)
      insert_transactions!(transactions)
      bank_transactions.categorize_all
    end
  end

  private

  def parse_file(file)
    statement_format.parse(file)
  end

  def insert_transactions!(transactions)
    BankTransaction.insert_all!(transactions.each { |tx| tx[:statement_id] = id })
  end
end
