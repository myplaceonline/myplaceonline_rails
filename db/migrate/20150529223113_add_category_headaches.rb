class AddCategoryHeadaches < ActiveRecord::Migration
  def change
    Category.create(name: "headaches", link: "headaches", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/emotion_fire.png")
  end
end
