class AddColumnToCalculationForm < ActiveRecord::Migration
  def change
    add_column :calculation_forms, :is_duplicate, :boolean
  end
end
