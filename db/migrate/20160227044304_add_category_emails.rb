class AddCategoryEmails < ActiveRecord::Migration
  def change
    Category.create(name: "emails", link: "emails", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/email.png")
  end
end
