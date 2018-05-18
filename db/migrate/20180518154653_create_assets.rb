class CreateAssets < ActiveRecord::Migration[5.1]
  def change
    create_table :financial_assets do |t|
      t.string :asset_name
      t.decimal :asset_value, precision: 10, scale: 2
      t.string :asset_location
      t.datetime :asset_received
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
