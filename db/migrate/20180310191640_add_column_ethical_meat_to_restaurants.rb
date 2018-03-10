class AddColumnEthicalMeatToRestaurants < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :ethical_meat, :boolean
  end
end
