class AddCategoryMediaDumps < ActiveRecord::Migration
  def change
    Category.create(name: "media_dumps", link: "media_dumps", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/bin_empty.png")
  end
end
