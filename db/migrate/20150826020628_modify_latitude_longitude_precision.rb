class ModifyLatitudeLongitudePrecision < ActiveRecord::Migration
  def change
    change_column :locations, :latitude, :decimal, :precision => 12, :scale => 8
    change_column :locations, :longitude, :decimal, :precision => 12, :scale => 8
  end
end
