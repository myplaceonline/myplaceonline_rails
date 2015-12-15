class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.references :contact, index: true
      t.text :conversation

      t.timestamps null: true
    end
  end
end
