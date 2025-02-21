class CreateWearables < ActiveRecord::Migration[6.1]
  def change
    create_table :wearables do |t|
      t.string :name
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.boolean :is_public
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
