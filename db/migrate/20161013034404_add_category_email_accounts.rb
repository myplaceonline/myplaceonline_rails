class AddCategoryEmailAccounts < ActiveRecord::Migration
  def change
    Category.create(name: "email_accounts", link: "email_accounts", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/email_accounts.png")
  end
end
