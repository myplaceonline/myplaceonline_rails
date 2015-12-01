class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.date :start_date
      t.integer :period_type
      t.integer :period
      t.references :owner, index: true

      t.timestamps
    end
  end
end
