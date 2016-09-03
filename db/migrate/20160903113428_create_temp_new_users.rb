class CreateTempNewUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :temp_new_users do |t|
      t.string :name
      t.string :email
      t.integer :phone
      t.string :key

      t.timestamps
    end
  end
end
