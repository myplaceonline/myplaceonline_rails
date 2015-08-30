class AddCategoryStatuses < ActiveRecord::Migration
  def change
    Category.create(name: "statuses", link: "statuses", position: 0, parent: Category.find_by_name("meaning"), icon: "FatCow_Icons16x16/emotion_draw.png")
  end
end
