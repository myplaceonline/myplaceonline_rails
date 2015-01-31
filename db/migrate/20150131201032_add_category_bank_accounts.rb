class AddCategoryBankAccounts < ActiveRecord::Migration
  def change
    Category.create(name: "bank_accounts", link: "bank_accounts", position: 0, parent: Category.find_by_name("order"))
  end
end
