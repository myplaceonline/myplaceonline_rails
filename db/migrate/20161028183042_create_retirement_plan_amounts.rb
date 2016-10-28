class CreateRetirementPlanAmounts < ActiveRecord::Migration
  def change
    create_table :retirement_plan_amounts do |t|
      t.references :retirement_plan, index: true, foreign_key: true
      t.date :input_date
      t.decimal :amount, precision: 10, scale: 2
      t.references :identity, index: true, foreign_key: true
      t.text :notes
      t.datetime :archived
      t.integer :rating

      t.timestamps null: false
    end
  end
end
