class AddCategoryDatingProfiles < ActiveRecord::Migration[5.0]
  def change
    Category.create(name: "dating_profiles", link: "dating_profiles", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/personals.png")
  end
end
