class AddEncryptionToDiaryEntries < ActiveRecord::Migration
  def change
    add_reference :diary_entries, :entry_encrypted, index: true, foreign_key: false
    add_foreign_key :diary_entries, :encrypted_values, column: :entry_encrypted_id
  end
end
