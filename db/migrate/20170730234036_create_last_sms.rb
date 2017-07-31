class CreateLastSms < ActiveRecord::Migration[5.1]
  def change
    create_table :last_text_messages do |t|
      t.string :phone_number
      t.string :category
      t.references :identity, foreign_key: true

      t.timestamps
    end
    add_index :last_text_messages, :phone_number
  end
end
