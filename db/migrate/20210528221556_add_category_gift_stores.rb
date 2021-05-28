class AddCategoryGiftStores < ActiveRecord::Migration[6.1]
  def change
    Category.create(name: "gift_stores", link: "gift_stores", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/gift_add.png", additional_filtertext: "cabinet curiosity curiosities antique macabre morbid interesting present")
  end
end
