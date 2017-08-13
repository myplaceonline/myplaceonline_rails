class AddCategoryBeaches < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "beaches", link: "beaches", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/weather_sun.png")
  end
end
