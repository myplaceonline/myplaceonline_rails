class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :always_autofocus, :boolean
  end
end
