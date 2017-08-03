class ChangeLastTextMessageColumns < ActiveRecord::Migration[5.1]
  def change
    rename_column :last_text_messages, :identity_id, :from_identity_id
    add_reference :last_text_messages, :to_identity, index: true
    add_foreign_key :last_text_messages, :identities, column: :to_identity_id
  end
end
