class CreateTripStories < ActiveRecord::Migration
  def change
    create_table :trip_stories do |t|
      t.references :trip, index: true, foreign_key: true
      t.references :story, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
