class AddLandlordToApartments < ActiveRecord::Migration
  def change
    add_reference :apartments, :landlord, index: true
  end
end
