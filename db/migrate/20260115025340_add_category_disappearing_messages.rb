class AddCategoryDisappearingMessages < ActiveRecord::Migration[6.1]
  def change
    Category.create(name: "disappearing_messages", link: "disappearing_messages", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/mail_black.png")
  end
end
