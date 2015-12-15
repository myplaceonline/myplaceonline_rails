class CreateDoctorVisits < ActiveRecord::Migration
  def change
    create_table :doctor_visits do |t|
      t.date :visit_date
      t.text :notes
      t.references :doctor, index: true
      t.references :health_insurance, index: true
      t.decimal :paid, precision: 10, scale: 2
      t.boolean :physical
      t.references :owner, index: true

      t.timestamps null: true
    end
  end
end
