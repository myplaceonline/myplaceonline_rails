class AddColumnsToComputers < ActiveRecord::Migration
  def change
    add_column :computers, :hostname, :string
  end
end
