class AddColumnCostToHospitalVisits < ActiveRecord::Migration[5.2]
  def change
    add_column :hospital_visits, :cost, :decimal, precision: 10, scale: 2
  end
end
