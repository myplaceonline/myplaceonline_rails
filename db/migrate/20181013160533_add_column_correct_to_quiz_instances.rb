class AddColumnCorrectToQuizInstances < ActiveRecord::Migration[5.1]
  def change
    add_column :quiz_instances, :correct, :integer
  end
end
