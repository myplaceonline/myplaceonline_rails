class CreateFeedLoadStatuses < ActiveRecord::Migration
  def change
    create_table :feed_load_statuses do |t|
      t.integer :items_total
      t.integer :items_complete
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
