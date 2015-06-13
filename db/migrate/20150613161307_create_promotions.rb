class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.string :promotion_name
      t.date :started
      t.date :expires
      t.decimal :promotion_amount, precision: 10, scale: 2
      t.text :notes
      t.references :identity, index: true

      t.timestamps
    end
  end
end
