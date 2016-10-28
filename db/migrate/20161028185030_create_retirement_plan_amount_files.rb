class CreateRetirementPlanAmountFiles < ActiveRecord::Migration
  def change
    create_table :retirement_plan_amount_files do |t|
      t.references :retirement_plan_amount, index: true, foreign_key: true
      t.references :identity_file, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
