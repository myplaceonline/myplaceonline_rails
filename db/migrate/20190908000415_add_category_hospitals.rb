class AddCategoryHospitals < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "hospitals", link: "hospitals", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/hospital.png")
  end
end
