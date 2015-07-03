class CreateDesiredProducts < ActiveRecord::Migration
  def change
    create_table :desired_products do |t|
      t.string :product_name
      t.text :notes
      t.references :identity, index: true

      t.timestamps
    end
  end
end
