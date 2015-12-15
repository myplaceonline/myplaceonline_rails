class CreateMyplaceonlineDueDisplays < ActiveRecord::Migration
  def change
    create_table :myplaceonline_due_displays do |t|
      t.boolean :trash
      t.references :owner, index: true

      t.timestamps null: true
    end
  end
end
