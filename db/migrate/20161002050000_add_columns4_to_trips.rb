class AddColumns4ToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :explicitly_completed, :boolean
  end
end
