class AddCategoryNotificationPreferences < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "notification_preferences", link: "notification_preferences", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/email_setting.png")
  end
end
