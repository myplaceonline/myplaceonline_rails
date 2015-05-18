class AddColumnsToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :situps, :integer
    add_column :exercises, :pushups, :integer
  end
end
