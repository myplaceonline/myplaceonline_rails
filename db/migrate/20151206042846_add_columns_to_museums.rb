class AddColumnsToMuseums < ActiveRecord::Migration
  def change
    add_column :museums, :museum_source, :string
  end
end
