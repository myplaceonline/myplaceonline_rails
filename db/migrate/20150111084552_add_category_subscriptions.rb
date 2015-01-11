class AddCategorySubscriptions < ActiveRecord::Migration
  def change
    Category.create(name: "subscriptions", link: "subscriptions", position: 0, parent: Category.find_by_name("order"))
  end
end
