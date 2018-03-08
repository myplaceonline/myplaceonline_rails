class AddColumnToMedicalConditionEvaluations < ActiveRecord::Migration[5.1]
  def change
    add_reference :medical_condition_evaluations, :location, foreign_key: true
  end
end
