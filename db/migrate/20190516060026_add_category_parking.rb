class AddCategoryParking < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "parking_locations", link: "parking_locations", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/car.png")
  end
end
