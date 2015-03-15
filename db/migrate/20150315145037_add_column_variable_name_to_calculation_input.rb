class AddColumnVariableNameToCalculationInput < ActiveRecord::Migration
  def change
    add_column :calculation_inputs, :variable_name, :string
  end
end
