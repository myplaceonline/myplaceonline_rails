class AddFileToDriversLicense < ActiveRecord::Migration
  def change
    add_reference :identity_drivers_licenses, :identity_file
  end
end
