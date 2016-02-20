class AddColumnsToTrips < ActiveRecord::Migration
  def change
    add_reference :trips, :hotel, index: true, foreign_key: true
  end
end
