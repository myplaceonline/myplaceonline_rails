class CreateCalculationOperands < ActiveRecord::Migration
  def change
    create_table :calculation_operands do |t|
      t.string :constant_value
      t.references :calculation_element, index: true

      t.timestamps
    end
  end
end
