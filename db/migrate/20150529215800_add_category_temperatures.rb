class AddCategoryTemperatures < ActiveRecord::Migration
  def change
    Category.create(name: "temperatures", link: "temperatures", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/temperature_warm.png")
  end
end
