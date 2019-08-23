class AddColumnCategoryToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :notification_category, :string
  end
end
