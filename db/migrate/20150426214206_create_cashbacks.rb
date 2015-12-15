class CreateCashbacks < ActiveRecord::Migration
  def change
    create_table :cashbacks do |t|
      t.references :identity, index: true
      t.decimal :cashback_percentage, precision: 10, scale: 2
      t.string :applies_to
      t.date :start_date
      t.date :end_date
      t.decimal :yearly_maximum, precision: 10, scale: 2
      t.text :notes

      t.timestamps null: true
    end
  end
end
