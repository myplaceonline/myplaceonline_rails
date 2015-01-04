class AddCategoryLocations < ActiveRecord::Migration
  def change
    Category.create(name: "locations", link: "locations", position: 0, parent: Category.find_by_name("order"))
  end
end
