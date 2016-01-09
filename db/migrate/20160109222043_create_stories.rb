class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :story_name
      t.text :story
      t.datetime :story_time
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
