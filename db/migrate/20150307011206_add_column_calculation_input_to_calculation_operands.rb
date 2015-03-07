class AddColumnCalculationInputToCalculationOperands < ActiveRecord::Migration
  def change
    change_table :calculation_operands do |t|
      t.belongs_to :calculation_input
    end
  end
end
