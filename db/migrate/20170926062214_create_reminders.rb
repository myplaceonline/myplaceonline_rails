class CreateReminders < ActiveRecord::Migration[5.1]
  def change
    create_table :reminders do |t|
      t.datetime :start_time
      t.integer :reminder_threshold_amount
      t.integer :reminder_threshold_type
      t.integer :expire_amount
      t.integer :expire_type
      t.integer :repeat_amount
      t.integer :repeat_type
      t.integer :max_pending
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
