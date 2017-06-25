class AddCategoryDietaryRequirements < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "dietary_requirements", link: "dietary_requirements", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/show_accounts_over_quota.png")
  end
end
