class AddCategoryDentalInsurances < ActiveRecord::Migration
  def change
    Category.create(name: "dental_insurances", link: "dental_insurances", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/tooth.png")
  end
end
