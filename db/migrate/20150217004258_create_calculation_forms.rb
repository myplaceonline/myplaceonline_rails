class CreateCalculationForms < ActiveRecord::Migration
  def change
    create_table :calculation_forms do |t|
      t.string :name
      t.references :identity, index: true

      t.timestamps
    end
  end
end
