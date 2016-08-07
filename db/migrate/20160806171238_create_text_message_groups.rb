class CreateTextMessageGroups < ActiveRecord::Migration
  def change
    create_table :text_message_groups do |t|
      t.references :text_message, index: true, foreign_key: true
      t.references :group, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
