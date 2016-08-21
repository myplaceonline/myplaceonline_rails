class AddCategoryReferences < ActiveRecord::Migration
  def change
    Category.create(name: "myreferences", link: "myreferences", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/client_account_template.png")
  end
end
