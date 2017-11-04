class ChangeMedCondTreatmentCol < ActiveRecord::Migration[5.1]
  def change
    change_column :medical_condition_treatments, :treatment_date, :datetime
  end
end
