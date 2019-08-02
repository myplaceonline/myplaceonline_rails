class AddCategoryVideos < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "videos", link: "videos", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/video.png")
  end
end
