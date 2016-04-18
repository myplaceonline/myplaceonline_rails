class AddColumns3ToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :notify_emergency_contacts, :boolean
  end
end
