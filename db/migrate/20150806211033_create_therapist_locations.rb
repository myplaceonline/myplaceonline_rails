class CreateTherapistLocations < ActiveRecord::Migration
  def change
    create_table :therapist_locations do |t|
      t.references :owner, index: true
      t.references :therapist, index: true
      t.references :location, index: true

      t.timestamps
    end
  end
end
