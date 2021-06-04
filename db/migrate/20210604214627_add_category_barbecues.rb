class AddCategoryBarbecues < ActiveRecord::Migration[6.1]
  def change
    Category.create(name: "barbecues", link: "barbecues", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/steak_meat.png", additional_filtertext: "restaurant food bbq")
  end
end
