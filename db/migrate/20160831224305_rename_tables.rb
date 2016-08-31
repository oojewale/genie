class RenameTables < ActiveRecord::Migration[5.0]
  def change
    rename_table :transactions, :activities
    rename_table :transaction_logs, :activity_logs
  end
end
