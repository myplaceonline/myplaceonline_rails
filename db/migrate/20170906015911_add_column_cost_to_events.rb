class AddColumnCostToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :cost, :decimal, precision: 10, scale: 2
  end
end
