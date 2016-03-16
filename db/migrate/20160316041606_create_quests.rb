class CreateQuests < ActiveRecord::Migration
  def change
    create_table :quests do |t|
      t.string :quest_title
      t.text :notes
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
