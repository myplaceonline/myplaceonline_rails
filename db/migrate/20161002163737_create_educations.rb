class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.string :education_name
      t.date :education_start
      t.date :education_end
      t.decimal :gpa, precision: 10, scale: 2
      t.references :location, index: true, foreign_key: true
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.string :degree_name
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
