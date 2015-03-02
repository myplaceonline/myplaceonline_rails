class AddColumnToCalculationElements < ActiveRecord::Migration
  def change
    add_reference :calculation_forms, :root_element, index: true
  end
end
