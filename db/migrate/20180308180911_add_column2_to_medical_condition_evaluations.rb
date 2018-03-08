class AddColumn2ToMedicalConditionEvaluations < ActiveRecord::Migration[5.1]
  def change
    add_reference :medical_condition_evaluations, :doctor, foreign_key: true
  end
end
