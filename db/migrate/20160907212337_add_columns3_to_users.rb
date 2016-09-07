class AddColumns3ToUsers < ActiveRecord::Migration
  def change
    add_column :users, :top_left_icon, :integer
  end
end
