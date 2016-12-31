class AddCategoryTestObjects < ActiveRecord::Migration[5.0]
  def change
    Category.create(name: "test_objects", link: "test_objects", position: 0, parent: Category.find_by_name("obscure"), icon: "FatCow_Icons16x16/trojan_horse.png", experimental: true)
  end
end
