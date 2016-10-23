class AddColumns5ToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :trip_name, :string
  end
end
