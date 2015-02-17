class AddCategoryCalculationForms < ActiveRecord::Migration
  def change
    Category.create(name: "calculation_forms", link: "calculation_forms", position: 0, parent: Category.find_by_name("order"))
  end
end
