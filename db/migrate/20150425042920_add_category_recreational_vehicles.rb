class AddCategoryRecreationalVehicles < ActiveRecord::Migration
  def change
    Category.create(name: "recreational_vehicles", link: "recreational_vehicles", position: 0, parent: Category.find_by_name("order"))
  end
end
