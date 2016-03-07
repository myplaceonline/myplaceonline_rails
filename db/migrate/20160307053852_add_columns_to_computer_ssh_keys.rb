class AddColumnsToComputerSshKeys < ActiveRecord::Migration
  def change
    add_column :computer_ssh_keys, :username, :string
  end
end
