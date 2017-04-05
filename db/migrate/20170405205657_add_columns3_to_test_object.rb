class AddColumns3ToTestObject < ActiveRecord::Migration[5.0]
  def change
    add_column :test_objects, :test_object_currency, :decimal, precision: 10, scale: 2
  end
end
