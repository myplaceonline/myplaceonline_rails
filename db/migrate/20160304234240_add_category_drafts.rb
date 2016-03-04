class AddCategoryDrafts < ActiveRecord::Migration
  def change
    Category.create(name: "drafts", link: "drafts", position: 0, parent: Category.find_by_name("obscure"), icon: "FatCow_Icons16x16/draft.png")
  end
end
