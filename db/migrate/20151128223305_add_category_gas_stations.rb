class AddCategoryGasStations < ActiveRecord::Migration
  def change
    Category.create(name: "gas_stations", link: "gas_stations", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/gas.png")
  end
end
