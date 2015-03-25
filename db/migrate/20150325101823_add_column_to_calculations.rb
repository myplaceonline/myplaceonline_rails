class AddColumnToCalculations < ActiveRecord::Migration
  def change
    add_reference :calculations, :original_calculation_form
  end
end
