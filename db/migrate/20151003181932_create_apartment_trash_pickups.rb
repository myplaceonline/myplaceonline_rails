class CreateApartmentTrashPickups < ActiveRecord::Migration
  def change
    create_table :apartment_trash_pickups do |t|
      t.integer :trash_type
      t.date :start_date
      t.integer :period_type
      t.integer :period
      t.text :notes
      t.references :apartment, index: true
      t.references :owner, index: true

      t.timestamps
    end
  end
end
