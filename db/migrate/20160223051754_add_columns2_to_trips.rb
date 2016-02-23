class AddColumns2ToTrips < ActiveRecord::Migration
  def change
    add_reference :trips, :identity_file, index: true, foreign_key: true
  end
end
