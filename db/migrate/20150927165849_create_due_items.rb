class CreateDueItems < ActiveRecord::Migration
  def change
    create_table :due_items do |t|
      t.string :display
      t.string :link
      t.datetime :due_date
      t.string :model_name
      t.integer :model_id
      t.references :owner, index: true

      t.timestamps null: true
    end
  end
end
