class AddIdentityColumnToIdentityDriversLicenses < ActiveRecord::Migration
  def change
    add_reference :identity_drivers_licenses, :identity
  end
end
