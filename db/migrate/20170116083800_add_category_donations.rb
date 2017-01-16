class AddCategoryDonations < ActiveRecord::Migration[5.0]
  def change
    Category.create(name: "donations", link: "donations", position: 0, parent: Category.find_by_name("finance"), icon: "FatCow_Icons16x16/coins_in_hand.png")
  end
end
