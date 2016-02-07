class AddColumnsToLocations < ActiveRecord::Migration
  def change
    add_reference :locations, :website, index: true, foreign_key: true
  end
end
