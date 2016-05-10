class AddColumns5ToUsers < ActiveRecord::Migration
  def change
    add_column :users, :always_enable_debug, :boolean
  end
end
