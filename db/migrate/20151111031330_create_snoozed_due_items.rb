class CreateSnoozedDueItems < ActiveRecord::Migration
  def change
    create_table :snoozed_due_items do |t|
      t.references :owner, index: true
      t.string :display
      t.string :link
      t.datetime :due_date
      t.datetime :original_due_date
      t.string :model_name
      t.integer :model_id

      t.timestamps
    end
  end
end
