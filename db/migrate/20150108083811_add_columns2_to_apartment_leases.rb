class AddColumns2ToApartmentLeases < ActiveRecord::Migration
  def change
    add_column :apartment_leases, :terminate_by, :date
  end
end
