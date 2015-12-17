class AddColumnsToToDos < ActiveRecord::Migration
  def change
    add_column :to_dos, :due_time, :datetime
  end
end
