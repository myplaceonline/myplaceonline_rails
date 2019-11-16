class AddCategoryVehicleWashes < ActiveRecord::Migration[5.2]
  def change
    Category.create(name: "vehicle_washes", link: "vehicle_washes", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/broom.png", additional_filtertext: "cars rvs trucks recreational")
  end
end
