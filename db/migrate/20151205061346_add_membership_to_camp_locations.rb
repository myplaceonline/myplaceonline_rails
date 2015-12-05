class AddMembershipToCampLocations < ActiveRecord::Migration
  def change
    add_reference :camp_locations, :membership, index: true
  end
end
