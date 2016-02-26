class AddColumnShowTimestampsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :show_timestamps, :boolean
  end
end
