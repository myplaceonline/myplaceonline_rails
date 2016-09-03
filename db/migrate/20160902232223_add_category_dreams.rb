class AddCategoryDreams < ActiveRecord::Migration
  def change
    Category.create(name: "dreams", link: "dreams", position: 0, parent: Category.find_by_name("meaning"), icon: "FatCow_Icons16x16/brain_trainer.png")
  end
end
