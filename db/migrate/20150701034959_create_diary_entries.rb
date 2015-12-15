class CreateDiaryEntries < ActiveRecord::Migration
  def change
    create_table :diary_entries do |t|
      t.datetime :diary_time
      t.text :entry
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
