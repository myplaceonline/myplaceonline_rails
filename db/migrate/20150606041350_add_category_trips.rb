class AddCategoryTrips < ActiveRecord::Migration
  def change
    Category.create(name: "trips", link: "trips", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/location_pin.png")
  end
end
