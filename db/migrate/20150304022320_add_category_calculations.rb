class AddCategoryCalculations < ActiveRecord::Migration
  def change
    Category.create(name: "calculations", link: "calculations", position: 0, parent: Category.find_by_name("order"))
  end
end
