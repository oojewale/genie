class CreateTempTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :temp_transactions do |t|
      t.integer :amount
      t.integer :sender_id
      t.integer :receiver_id

      t.timestamps
    end
  end
end
