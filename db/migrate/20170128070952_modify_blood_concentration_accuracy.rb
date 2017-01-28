class ModifyBloodConcentrationAccuracy < ActiveRecord::Migration[5.0]
  def change
    change_column :blood_concentrations, :concentration_minimum, :decimal, :precision => 10, :scale => 3
    change_column :blood_concentrations, :concentration_maximum, :decimal, :precision => 10, :scale => 3
    change_column :blood_test_results, :concentration, :decimal, :precision => 10, :scale => 3
  end
end
