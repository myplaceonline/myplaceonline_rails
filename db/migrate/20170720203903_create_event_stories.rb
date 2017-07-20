class CreateEventStories < ActiveRecord::Migration[5.1]
  def change
    create_table :event_stories do |t|
      t.references :event, foreign_key: true
      t.references :story, foreign_key: true
      t.references :identity, foreign_key: true
      t.datetime :archived

      t.timestamps
    end
  end
end
