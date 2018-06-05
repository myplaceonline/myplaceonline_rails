class AddColumnFinalCostsToTrips < ActiveRecord::Migration[5.1]
  def change
    add_column :trips, :final_costs_additional, :decimal, precision: 10, scale: 2
    add_column :trips, :final_costs_transportation, :decimal, precision: 10, scale: 2
    add_column :trips, :final_costs_food, :decimal, precision: 10, scale: 2
  end
end
