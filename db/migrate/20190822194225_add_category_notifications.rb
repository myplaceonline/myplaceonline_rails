class AddCategoryNotifications < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "notifications", link: "notifications", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/mail_box.png")
  end
end
