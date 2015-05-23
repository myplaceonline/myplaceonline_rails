class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.string :checklist_name
      t.references :identity, index: true

      t.timestamps
    end
  end
end
