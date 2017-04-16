class AddCategoryInsuranceCards < ActiveRecord::Migration[5.0]
  def change
    Category.create(name: "insurance_cards", link: "insurance_cards", position: 0, parent: Category.find_by_name("finance"), icon: "FatCow_Icons16x16/infocard.png")
  end
end
