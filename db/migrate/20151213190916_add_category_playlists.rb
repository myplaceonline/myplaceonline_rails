class AddCategoryPlaylists < ActiveRecord::Migration
  def change
    Category.create(name: "playlists", link: "playlists", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/ear_listen.png")
  end
end
