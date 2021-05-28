class AddCategoryMemes < ActiveRecord::Migration[6.1]
  def change
    Category.create(name: "memes", link: "memes", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/user_wicket.png")
  end
end
