class AddCategoryStories < ActiveRecord::Migration
  def change
    Category.create(name: "stories", link: "stories", position: 0, parent: Category.find_by_name("meaning"), icon: "FatCow_Icons16x16/system_monitor.png")
  end
end
