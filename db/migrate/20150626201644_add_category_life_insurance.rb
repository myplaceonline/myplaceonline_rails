class AddCategoryLifeInsurance < ActiveRecord::Migration
  def change
    Category.create(name: "life_insurances", link: "life_insurances", position: 0, parent: Category.find_by_name("finance"), icon: "FatCow_Icons16x16/skull_old.png")
  end
end
