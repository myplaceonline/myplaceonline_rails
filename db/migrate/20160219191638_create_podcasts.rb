class CreatePodcasts < ActiveRecord::Migration
  def change
    create_table :podcasts do |t|
      t.references :feed, index: true, foreign_key: true
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
