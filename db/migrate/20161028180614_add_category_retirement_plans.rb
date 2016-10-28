class AddCategoryRetirementPlans < ActiveRecord::Migration
  def change
    Category.create(name: "retirement_plans", link: "retirement_plans", position: 0, parent: Category.find_by_name("finance"), icon: "FatCow_Icons16x16/financial_functions.png")
  end
end
