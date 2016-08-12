class AddCategoryBusinessCards < ActiveRecord::Migration
  def change
    Category.create(name: "business_cards", link: "business_cards", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/vcard.png")
  end
end
