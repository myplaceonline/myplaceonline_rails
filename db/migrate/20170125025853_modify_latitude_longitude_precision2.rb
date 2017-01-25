class ModifyLatitudeLongitudePrecision2 < ActiveRecord::Migration[5.0]
  def change
    change_column :locations, :latitude, :decimal, :precision => 24, :scale => 20
    change_column :locations, :longitude, :decimal, :precision => 24, :scale => 20
  end
end
