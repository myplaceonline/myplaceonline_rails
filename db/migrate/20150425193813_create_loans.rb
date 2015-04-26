class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.string :lender
      t.decimal :amount, precision: 10, scale: 2
      t.date :start
      t.date :paid_off
      t.decimal :monthly_payment, precision: 10, scale: 2
      t.references :identity, index: true

      t.timestamps
    end
  end
end
