class DropExtraAtpColumns < ActiveRecord::Migration
  def change
    remove_column :apartment_trash_pickups, :start_date
    remove_column :apartment_trash_pickups, :period_type
    remove_column :apartment_trash_pickups, :period
  end
end
