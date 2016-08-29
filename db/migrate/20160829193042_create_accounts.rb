class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :account_num
      t.string :account_type
      t.boolean :active
      t.float :balance
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
