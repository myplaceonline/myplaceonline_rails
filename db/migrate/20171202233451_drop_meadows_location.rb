class DropMeadowsLocation < ActiveRecord::Migration[5.1]
  def change
    remove_column :meadows, :location_id
  end
end
