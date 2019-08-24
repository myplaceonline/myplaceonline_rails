class AddColumnCountToNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :count, :integer
  end
end
