class AddColumnDescriptionToQuizInstances < ActiveRecord::Migration[5.1]
  def change
    add_column :quiz_instances, :description, :string
  end
end
