class AddPayorAndPayeeToStatementFormats < ActiveRecord::Migration[7.2]
  def change
    add_column :statement_formats, :payor_col, :string
    add_column :statement_formats, :payee_col, :string
  end
end
