class AddColumnsToLifeInsurances < ActiveRecord::Migration[5.0]
  def change
    add_column :life_insurances, :cash_value, :decimal, precision: 10, scale: 2
    add_reference :life_insurances, :beneficiary, foreign_key: false
    add_column :life_insurances, :loan_interest_rate, :decimal, precision: 10, scale: 2
    add_foreign_key :life_insurances, :contacts, column: :beneficiary_id
  end
end
