class AddColumnsToApartments < ActiveRecord::Migration
  def change
    add_column :apartments, :notes, :text
  end
end
