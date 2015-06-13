class AddCategoryPromotions < ActiveRecord::Migration
  def change
    Category.create(name: "promotions", link: "promotions", position: 0, parent: Category.find_by_name("finance"), icon: "FatCow_Icons16x16/coins_in_hand.png")
  end
end
