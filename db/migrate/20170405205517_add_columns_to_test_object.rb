class AddColumnsToTestObject < ActiveRecord::Migration[5.0]
  def change
    add_reference :test_objects, :contact, foreign_key: true
  end
end
