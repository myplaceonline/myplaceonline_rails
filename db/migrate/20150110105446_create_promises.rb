class CreatePromises < ActiveRecord::Migration
  def change
    create_table :promises do |t|
      t.string :name
      t.date :due
      t.text :promise
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
