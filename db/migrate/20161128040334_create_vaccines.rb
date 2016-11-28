class CreateVaccines < ActiveRecord::Migration
  def change
    create_table :vaccines do |t|
      t.string :vaccine_name
      t.date :vaccine_date
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
