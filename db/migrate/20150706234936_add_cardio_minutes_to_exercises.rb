class AddCardioMinutesToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :cardio_time, :integer
  end
end
