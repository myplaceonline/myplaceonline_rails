class AddCategoryReminders < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "reminders", link: "reminders", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/time.png")
  end
end
