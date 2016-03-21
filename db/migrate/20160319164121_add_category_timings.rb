class AddCategoryTimings < ActiveRecord::Migration
  def change
    Category.create(name: "timings", link: "timings", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/time.png")
  end
end
