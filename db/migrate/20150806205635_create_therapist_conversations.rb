class CreateTherapistConversations < ActiveRecord::Migration
  def change
    create_table :therapist_conversations do |t|
      t.references :owner, index: true
      t.references :therapist, index: true
      t.text :conversation
      t.date :conversation_date

      t.timestamps null: true
    end
  end
end
