class AddCategoryApartments < ActiveRecord::Migration
  def change
    Category.create(name: "apartments", link: "apartments", position: 0, parent: Category.find_by_name("order"))
  end
end
