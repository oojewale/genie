class AddColumnUserIdToConversationContexts < ActiveRecord::Migration[5.0]
  def change
    add_reference :conversation_contexts, :user, foreign_key: true
  end
end
