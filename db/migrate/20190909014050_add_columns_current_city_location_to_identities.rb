class AddColumnsCurrentCityLocationToIdentities < ActiveRecord::Migration[5.1]
  def change
    add_column :identities, :current_city_latitude, :decimal, precision: 24, scale: 20
    add_column :identities, :current_city_longitude, :decimal, precision: 24, scale: 20
  end
end
