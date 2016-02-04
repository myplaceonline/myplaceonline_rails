class CreateCalendarItems < ActiveRecord::Migration
  def change
    create_table :calendar_items do |t|
      t.references :calendar, index: true, foreign_key: true
      t.datetime :calendar_item_time
      t.text :notes
      t.boolean :persistent
      t.integer :repeat_amount
      t.integer :repeat_type
      t.string :model_class
      t.integer :model_id
      t.references :identity, index: true, foreign_key: true
      t.boolean :is_repeat

      t.timestamps null: false
    end
  end
end
