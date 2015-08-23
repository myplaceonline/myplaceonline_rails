class AddCategoryPoems < ActiveRecord::Migration
  def change
    Category.create(name: "poems", link: "poems", position: 0, parent: Category.find_by_name("meaning"), icon: "FatCow_Icons16x16/quill.png")
  end
end
