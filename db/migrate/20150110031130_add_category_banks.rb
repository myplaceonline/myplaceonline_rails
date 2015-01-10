class AddCategoryBanks < ActiveRecord::Migration
  def change
    Category.create(name: "banks", link: "banks", position: 0, parent: Category.find_by_name("order"))
  end
end
