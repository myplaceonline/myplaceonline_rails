class CreateCompleteDueItems < ActiveRecord::Migration
  def change
    create_table :complete_due_items do |t|
      t.references :owner, index: true
      t.string :display
      t.string :link
      t.datetime :due_date
      t.string :model_name
      t.integer :model_id

      t.timestamps null: true
    end
  end
end
