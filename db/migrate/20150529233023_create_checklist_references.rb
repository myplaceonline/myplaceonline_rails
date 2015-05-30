class CreateChecklistReferences < ActiveRecord::Migration
  def change
    create_table :checklist_references do |t|
      t.references :checklist_parent, index: true
      t.references :checklist, index: true
      t.references :identity, index: true
      t.boolean :pre_checklist

      t.timestamps
    end
  end
end
