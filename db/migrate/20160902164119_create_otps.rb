class CreateOtps < ActiveRecord::Migration[5.0]
  def change
    create_table :otps do |t|
      t.string :value
      t.boolean :status
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
