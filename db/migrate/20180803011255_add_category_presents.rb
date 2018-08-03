class AddCategoryPresents < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "presents", link: "presents", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/card_gift_2.png")
  end
end
