class CreateCalendarItemReminderPendings < ActiveRecord::Migration
  def change
    create_table :calendar_item_reminder_pendings do |t|
      t.references :calendar_item_reminder, index: {:name => "index_calendar_item_reminder_pendings_on_cir_id"}, foreign_key: true
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
