class AddCategorySshKeys < ActiveRecord::Migration
  def change
    Category.create(name: "ssh_keys", link: "ssh_keys", position: 0, parent: Category.find_by_name("obscure"), icon: "FatCow_Icons16x16/ssh_shell_access.png")
  end
end
