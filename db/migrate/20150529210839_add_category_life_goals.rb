class AddCategoryLifeGoals < ActiveRecord::Migration
  def change
    Category.create(name: "life_goals", link: "life_goals", position: 0, parent: Category.find_by_name("meaning"), icon: "FatCow_Icons16x16/compass.png")
  end
end
