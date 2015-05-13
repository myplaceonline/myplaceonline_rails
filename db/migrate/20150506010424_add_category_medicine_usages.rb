class AddCategoryMedicineUsages < ActiveRecord::Migration
  def change
    Category.create(name: "medicine_usages", link: "medicine_usages", position: 0, parent: Category.find_by_name("health"))
  end
end
