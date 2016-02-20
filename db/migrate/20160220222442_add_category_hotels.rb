class AddCategoryHotels < ActiveRecord::Migration
  def change
    Category.create(name: "hotels", link: "hotels", position: 0, parent: Category.find_by_name("order"), icon: "famfamfam/building.png")
  end
end
