class AddCategorySongs < ActiveRecord::Migration
  def change
    Category.create(name: "songs", link: "songs", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/music.png")
  end
end
