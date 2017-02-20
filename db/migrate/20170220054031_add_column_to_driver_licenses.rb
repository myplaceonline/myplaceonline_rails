class AddColumnToDriverLicenses < ActiveRecord::Migration[5.0]
  def change
    add_column :driver_licenses, :region, :string
  end
end
