class CreateTextMessageUnsubscriptions < ActiveRecord::Migration
  def change
    create_table :text_message_unsubscriptions do |t|
      t.string :phone_number
      t.string :category
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
