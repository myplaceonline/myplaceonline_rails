class AddCategoryMerchantAccounts < ActiveRecord::Migration[6.1]
  def change
    Category.create(name: "merchant_accounts", link: "merchant_accounts", position: 0, parent: Category.find_by_name("finance"), icon: "FatCow_Icons16x16/cash_register_right.png", additional_filtertext: "pos point of sale")
  end
end
