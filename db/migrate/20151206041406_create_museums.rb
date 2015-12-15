class CreateMuseums < ActiveRecord::Migration
  def change
    create_table :museums do |t|
      t.references :location, index: true
      t.string :museum_id
      t.references :website, index: true
      t.integer :museum_type
      t.text :notes
      t.integer :visit_count
      t.references :owner, index: true

      t.timestamps null: true
    end
  end
end
