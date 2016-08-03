class AddColumnsToMedicalConditionTreatments < ActiveRecord::Migration
  def change
    add_reference :medical_condition_treatments, :location, index: true, foreign_key: true
  end
end
