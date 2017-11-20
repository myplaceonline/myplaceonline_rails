class AddCategoryPublicSearch < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "public_searches", link: "public_searches", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/magnifier.png", internal: true)
  end
end
