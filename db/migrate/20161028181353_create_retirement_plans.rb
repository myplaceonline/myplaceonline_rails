class CreateRetirementPlans < ActiveRecord::Migration
  def change
    create_table :retirement_plans do |t|
      t.string :retirement_plan_name
      t.integer :retirement_plan_type
      t.references :company, index: true, foreign_key: true
      t.references :periodic_payment, index: true, foreign_key: true
      t.date :started
      t.text :notes
      t.references :password, index: true, foreign_key: true
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
