class AddCategoryMedicalChanges < ActiveRecord::Migration[5.2]
  def up
    Category.create(name: "health_changes", link: "health_changes", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/report_user.png")
  end

  def down
    Category.where(name: "health_changes").destroy_all
  end
end
