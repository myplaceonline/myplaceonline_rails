class AddCategoryLicenses < ActiveRecord::Migration[5.0]
  def change
    Category.create(name: "licenses", link: "licenses", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/license_key.png")
  end
end
