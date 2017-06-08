class AddCategoryUserCapabilities < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "user_capabilities", link: "user_capabilities", position: 0, parent: Category.find_by_name("obscure"), icon: "FatCow_Icons16x16/user_ninja.png", experimental: true)
  end
end
