class CreatePassports < ActiveRecord::Migration
  def change
    create_table :passports do |t|
      t.string :region
      t.string :passport_number
      t.date :expires
      t.date :issued
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
