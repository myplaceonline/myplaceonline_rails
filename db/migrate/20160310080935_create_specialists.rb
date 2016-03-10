class CreateSpecialists < ActiveRecord::Migration
  def change
    create_table :specialists do |t|
      t.references :contact, index: true, foreign_key: true
      t.integer :specialist_type
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
