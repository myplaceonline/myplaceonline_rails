class AddColumnEventToTrips < ActiveRecord::Migration[5.1]
  def change
    add_reference :trips, :event, foreign_key: true
  end
end
