class AddCategoryPodcasts < ActiveRecord::Migration
  def change
    Category.create(name: "podcasts", link: "podcasts", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/ipod_cast.png")
  end
end
