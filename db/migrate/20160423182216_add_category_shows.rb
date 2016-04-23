class AddCategoryShows < ActiveRecord::Migration
  def change
    Category.create(name: "tv_shows", link: "tv_shows", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/television.png")
  end
end
