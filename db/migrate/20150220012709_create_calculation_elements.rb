class CreateCalculationElements < ActiveRecord::Migration
  def change
    create_table :calculation_elements do |t|
      t.references :left_operand, index: true
      t.references :right_operand, index: true
      t.integer :operator

      t.timestamps
    end
  end
end
