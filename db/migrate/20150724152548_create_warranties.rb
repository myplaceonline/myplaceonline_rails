class CreateWarranties < ActiveRecord::Migration
  def change
    create_table :warranties do |t|
      t.string :warranty_name
      t.date :warranty_start
      t.date :warranty_end
      t.string :warranty_condition
      t.text :notes
      t.references :owner, index: true

      t.timestamps
    end
  end
end
