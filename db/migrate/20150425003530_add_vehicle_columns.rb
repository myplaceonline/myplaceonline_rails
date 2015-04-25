class AddVehicleColumns < ActiveRecord::Migration
  def change
    add_column :vehicles, :trim_name, :string
    add_column :vehicles, :dimensions_type, :integer
    add_column :vehicles, :height, :decimal, precision: 10, scale: 2
    add_column :vehicles, :width, :decimal, precision: 10, scale: 2
    add_column :vehicles, :length, :decimal, precision: 10, scale: 2
    add_column :vehicles, :wheel_base, :decimal, precision: 10, scale: 2
    add_column :vehicles, :ground_clearance, :decimal, precision: 10, scale: 2
    add_column :vehicles, :weight_type, :integer
    add_column :vehicles, :doors_type, :integer
    add_column :vehicles, :passenger_seats, :integer
    add_column :vehicles, :gvwr, :decimal, precision: 10, scale: 2
    add_column :vehicles, :gcwr, :decimal, precision: 10, scale: 2
    add_column :vehicles, :gawr_front, :decimal, precision: 10, scale: 2
    add_column :vehicles, :gawr_rear, :decimal, precision: 10, scale: 2
    add_column :vehicles, :front_axle_details, :string
    add_column :vehicles, :front_axle_rating, :decimal, precision: 10, scale: 2
    add_column :vehicles, :front_suspension_details, :string
    add_column :vehicles, :front_suspension_rating, :decimal, precision: 10, scale: 2
    add_column :vehicles, :rear_axle_details, :string
    add_column :vehicles, :rear_axle_rating, :decimal, precision: 10, scale: 2
    add_column :vehicles, :rear_suspension_details, :string
    add_column :vehicles, :rear_suspension_rating, :decimal, precision: 10, scale: 2
    add_column :vehicles, :tire_details, :string
    add_column :vehicles, :tire_rating, :decimal, precision: 10, scale: 2
    add_column :vehicles, :tire_diameter, :decimal, precision: 10, scale: 2
    add_column :vehicles, :wheel_details, :string
    add_column :vehicles, :wheel_rating, :decimal, precision: 10, scale: 2
    add_column :vehicles, :engine_type, :integer
    add_column :vehicles, :wheel_drive_type, :integer
    add_column :vehicles, :wheels_type, :integer
    add_column :vehicles, :fuel_tank_capacity_type, :integer
    add_column :vehicles, :fuel_tank_capacity, :decimal, precision: 10, scale: 2
    add_column :vehicles, :wet_weight_front, :decimal, precision: 10, scale: 2
    add_column :vehicles, :wet_weight_rear, :decimal, precision: 10, scale: 2
    add_column :vehicles, :tailgate_weight, :decimal, precision: 10, scale: 2
    add_column :vehicles, :horsepower, :integer
    add_column :vehicles, :cylinders, :integer
    add_column :vehicles, :displacement_type, :integer
    add_column :vehicles, :doors, :integer
    add_column :vehicles, :displacement, :decimal, precision: 10, scale: 2
    add_column :vehicles, :bed_length, :decimal, precision: 10, scale: 2
  end
end
