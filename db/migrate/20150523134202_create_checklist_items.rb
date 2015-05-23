class CreateChecklistItems < ActiveRecord::Migration
  def change
    create_table :checklist_items do |t|
      t.string :checklist_item_name
      t.references :checklist, index: true
      t.integer :position
      t.references :identity, index: true

      t.timestamps
    end
  end
end
