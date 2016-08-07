class CreateAdminTextMessages < ActiveRecord::Migration
  def change
    create_table :admin_text_messages do |t|
      t.references :text_message, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.string :send_only_to
      t.string :exclude_numbers

      t.timestamps null: false
    end
  end
end
