class CreateWhatdidiwearthenLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :whatdidiwearthen_locations do |t|
      t.references :whatdidiwearthen, foreign_key: true
      t.references :location, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position
      t.boolean :is_public
      t.text :notes

      t.timestamps
    end
  end
end
