class AddLocationColumnsToTreks < ActiveRecord::Migration[5.1]
  def change
    add_reference :treks, :parking_location, foreign_key: false
    add_reference :treks, :end_location, foreign_key: false
    add_foreign_key :treks, :locations, column: :parking_location_id
    add_foreign_key :treks, :locations, column: :end_location_id
  end
end
