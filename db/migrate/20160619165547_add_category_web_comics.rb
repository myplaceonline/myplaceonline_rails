class AddCategoryWebComics < ActiveRecord::Migration
  def change
    Category.create(name: "web_comics", link: "web_comics", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/stickman.png")
  end
end
