class CreateApartmentLeases < ActiveRecord::Migration
  def change
    create_table :apartment_leases do |t|
      t.date :start_date
      t.date :end_date
      t.references :apartment, index: true

      t.timestamps
    end
  end
end
