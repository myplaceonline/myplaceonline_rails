class AddUserTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uesr_type, :integer
  end
end
