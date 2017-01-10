class AddColumns7ToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :show_server_name, :boolean
  end
end
