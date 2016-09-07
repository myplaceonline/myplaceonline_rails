class AddCategoryMessages < ActiveRecord::Migration
  def change
    Category.create(name: "messages", link: "messages", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/envelopes.png")
  end
end
