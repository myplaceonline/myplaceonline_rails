class AddColumnsToRegimens < ActiveRecord::Migration[5.1]
  def change
    add_column :regimens, :regimen_type, :integer
  end
end
