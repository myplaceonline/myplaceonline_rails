class AddColumns3ToHotels < ActiveRecord::Migration[5.1]
  def change
    add_column :hotels, :total_cost, :decimal, precision: 10, scale: 2
  end
end
