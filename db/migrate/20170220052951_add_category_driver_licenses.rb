class AddCategoryDriverLicenses < ActiveRecord::Migration[5.0]
  def change
    Category.create(name: "driver_licenses", link: "driver_licenses", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/form_photo.png")
  end
end
