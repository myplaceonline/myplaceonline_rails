class AddCategoryWeights < ActiveRecord::Migration
  def change
    Category.create(name: "weights", link: "weights", position: 0, parent: Category.find_by_name("health"))
  end
end
