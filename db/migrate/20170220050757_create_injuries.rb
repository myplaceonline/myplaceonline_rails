class CreateInjuries < ActiveRecord::Migration[5.0]
  def change
    create_table :injuries do |t|
      t.string :injury_name
      t.date :injury_date
      t.references :location, foreign_key: true
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
