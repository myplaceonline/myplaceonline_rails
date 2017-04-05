class AddColumns2ToTestObject < ActiveRecord::Migration[5.0]
  def change
    add_column :test_objects, :test_object_string, :string
    add_column :test_objects, :test_object_date, :date
    add_column :test_objects, :test_object_datetime, :datetime
    add_column :test_objects, :test_object_time, :time
    add_column :test_objects, :test_object_number, :integer
    add_column :test_objects, :test_object_decimal, :decimal, precision: 10, scale: 2
  end
end
