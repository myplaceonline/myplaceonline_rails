class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :link
      t.integer :position
      t.references :parent, index: true

      t.timestamps null: true
    end
    add_index :categories, :name, unique: true
  end
end
