class CreateLoginContexts < ActiveRecord::Migration[5.0]
  def change
    create_table :login_contexts do |t|
      t.string :key
      t.text :dialog_stack, array: true, default: ['root']
      t.integer :turn_counter
      t.integer :request_counter
      t.string :convo_id

      t.timestamps
    end
  end
end