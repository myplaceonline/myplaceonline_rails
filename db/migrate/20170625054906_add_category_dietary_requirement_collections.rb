class AddCategoryDietaryRequirementCollections < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "dietary_requirements_collections", link: "dietary_requirements_collections", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/tubes.png")
  end
end
