class RemoveSpecialists2 < ActiveRecord::Migration
  def change
    drop_table :specialists
    UserIndex.reset!
  end
end
