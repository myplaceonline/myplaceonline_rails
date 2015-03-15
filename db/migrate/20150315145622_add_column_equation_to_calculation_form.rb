class AddColumnEquationToCalculationForm < ActiveRecord::Migration
  def change
    add_column :calculation_forms, :equation, :text
  end
end
