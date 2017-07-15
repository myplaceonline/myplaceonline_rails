class AddColumnsToTestObjects < ActiveRecord::Migration[5.1]
  def change
    add_column :test_objects, :test_object_boolean, :boolean
  end
end
