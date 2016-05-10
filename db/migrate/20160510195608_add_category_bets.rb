class AddCategoryBets < ActiveRecord::Migration
  def change
    Category.create(name: "bets", link: "bets", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/chess_horse.png")
  end
end
