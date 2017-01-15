class AddCategoryPrescriptions < ActiveRecord::Migration[5.0]
  def change
    Category.create(name: "prescriptions", link: "prescriptions", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/document_yellow.png")
  end
end
