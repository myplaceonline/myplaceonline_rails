class AddCategoryDiaryEntries < ActiveRecord::Migration
  def change
    Category.create(name: "diary_entries", link: "diary_entries", position: 0, parent: Category.find_by_name("meaning"), icon: "FatCow_Icons16x16/report.png")
  end
end
