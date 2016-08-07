class CreateTextMessageContacts < ActiveRecord::Migration
  def change
    create_table :text_message_contacts do |t|
      t.references :text_message, index: true, foreign_key: true
      t.references :contact, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
