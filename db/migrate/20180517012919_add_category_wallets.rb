class AddCategoryWallets < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "wallets", link: "wallets", position: 0, parent: Category.find_by_name("finance"), icon: "FatCow_Icons16x16/wallet.png")
  end
end
