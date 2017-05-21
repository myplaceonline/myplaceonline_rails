class CreateSicknesses < ActiveRecord::Migration[5.1]
  def change
    create_table :sicknesses do |t|
      t.date :sickness_start
      t.date :sickness_end
      t.boolean :coughing
      t.boolean :sneezing
      t.boolean :throwing_up
      t.boolean :fever
      t.boolean :runny_nose
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
