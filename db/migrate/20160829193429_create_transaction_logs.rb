class CreateTransactionLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :transaction_logs do |t|
      t.string :transaction_code
      t.integer :customer_two_id
      t.boolean :completed
      t.references :transaction, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
