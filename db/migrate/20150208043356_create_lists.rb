class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :name
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
