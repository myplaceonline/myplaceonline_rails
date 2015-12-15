class CreateTherapists < ActiveRecord::Migration
  def change
    create_table :therapists do |t|
      t.string :name
      t.text :notes
      t.references :owner, index: true

      t.timestamps null: true
    end
  end
end
