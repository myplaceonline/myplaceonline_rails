class CreateCalendarItemReminders < ActiveRecord::Migration
  def change
    create_table :calendar_item_reminders do |t|
      t.integer :threshold_amount
      t.integer :threshold_type
      t.integer :repeat_amount
      t.integer :repeat_type
      t.integer :expire_amount
      t.integer :expire_type
      t.references :calendar_item, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
