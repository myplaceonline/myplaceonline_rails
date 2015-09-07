class AddCategoryConcerts < ActiveRecord::Migration
  def change
    Category.create(name: "concerts", link: "concerts", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/speakers.png")
  end
end
