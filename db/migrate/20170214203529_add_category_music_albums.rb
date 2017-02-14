class AddCategoryMusicAlbums < ActiveRecord::Migration[5.0]
  def change
    Category.create(name: "music_albums", link: "music_albums", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/cd_case.png")
  end
end
