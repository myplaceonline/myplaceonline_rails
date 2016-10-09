class AddColumns10ToUsers < ActiveRecord::Migration
  def change
    add_column :users, :suppressions, :integer
  end
end
