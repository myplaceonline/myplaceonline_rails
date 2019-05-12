class AddColumnsFootageToApartments < ActiveRecord::Migration[5.1]
  def change
    add_column :apartments, :total_square_footage, :integer
    add_column :apartments, :master_bedroom_square_footage, :integer
    add_column :apartments, :bedrooms, :decimal, precision: 10, scale: 2
    add_column :apartments, :bathrooms, :decimal, precision: 10, scale: 2
  end
end
