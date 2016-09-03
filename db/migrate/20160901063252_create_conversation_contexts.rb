class CreateConversationContexts < ActiveRecord::Migration[5.0]
  def change
    create_table :conversation_contexts do |t|
      t.string :key
      # t.text :dialog_stack, array: true, default: ['root']
      t.integer :turn_counter, default: 1
      t.integer :request_counter, default: 1
      t.string :convo_id

      t.timestamps
    end
  end
end
