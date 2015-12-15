class CreateDentistVisits < ActiveRecord::Migration
  def change
    create_table :dentist_visits do |t|
      t.date :visit_date
      t.integer :cavities
      t.text :notes
      t.references :dentist, index: true
      t.references :dental_insurance, index: true
      t.decimal :paid, precision: 10, scale: 2
      t.boolean :cleaning
      t.references :owner, index: true

      t.timestamps null: true
    end
  end
end
