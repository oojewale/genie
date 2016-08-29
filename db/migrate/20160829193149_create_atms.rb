class CreateAtms < ActiveRecord::Migration[5.0]
  def change
    create_table :atms do |t|
      t.string :atm_num
      t.string :card_type
      t.date :expiry
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
