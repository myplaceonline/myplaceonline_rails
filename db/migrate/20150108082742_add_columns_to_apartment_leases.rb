class AddColumnsToApartmentLeases < ActiveRecord::Migration
  def change
    add_column :apartment_leases, :monthly_rent, :decimal, precision: 10, scale: 2
    add_column :apartment_leases, :moveout_fee, :decimal, precision: 10, scale: 2
    add_column :apartment_leases, :deposit, :decimal, precision: 10, scale: 2
  end
end
