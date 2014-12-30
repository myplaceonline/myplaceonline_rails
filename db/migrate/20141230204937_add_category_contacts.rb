class AddCategoryContacts < ActiveRecord::Migration
  def change
    Category.create(name: "contacts", link: "contacts", position: 0, parent: Category.find_by_name("order"))
  end
end
