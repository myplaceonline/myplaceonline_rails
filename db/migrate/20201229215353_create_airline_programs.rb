class CreateAirlinePrograms < ActiveRecord::Migration[5.2]
  def change
    create_table :airline_programs do |t|
      t.string :program_name
      t.references :password, foreign_key: true
      t.references :membership, foreign_key: true
      t.string :status
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
