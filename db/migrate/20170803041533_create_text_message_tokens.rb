class CreateTextMessageTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :text_message_tokens do |t|
      t.string :phone_number
      t.string :token
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
