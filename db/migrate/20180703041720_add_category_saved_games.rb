class AddCategorySavedGames < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "saved_games", link: "saved_games", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/layer_save.png")
  end
end
