class AddCategoryMedicalConditions < ActiveRecord::Migration
  def change
    Category.create(name: "medical_conditions", link: "medical_conditions", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/medical_record.png")
  end
end
