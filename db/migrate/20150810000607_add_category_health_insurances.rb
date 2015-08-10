class AddCategoryHealthInsurances < ActiveRecord::Migration
  def change
    Category.create(name: "health_insurances", link: "health_insurances", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/support.png")
  end
end
