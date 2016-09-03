class CreateTempUserUpdates < ActiveRecord::Migration[5.0]
  def change
    create_table :temp_user_updates do |t|
      t.references :user, foreign_key: true
      t.string :email
      t.string :address
      t.string :phone

      t.timestamps
    end
  end
end
