class AddCategoryComputerEnvironment < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "computer_environments", link: "computer_environments", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/server.png", experimental: true)
  end
end
