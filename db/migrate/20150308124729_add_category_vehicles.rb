class AddCategoryVehicles < ActiveRecord::Migration
  def change
    Category.create(name: "vehicles", link: "vehicles", position: 0, parent: Category.find_by_name("order"))
  end
end
