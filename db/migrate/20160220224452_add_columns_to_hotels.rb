class AddColumnsToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :room_number, :integer
  end
end
