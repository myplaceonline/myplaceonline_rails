class AddCategoryPhones < ActiveRecord::Migration
  def change
    Category.create(name: "phones", link: "phones", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/phone.png")
  end
end
