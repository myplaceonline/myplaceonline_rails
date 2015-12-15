class CreateMyplets < ActiveRecord::Migration
  def change
    create_table :myplets do |t|
      t.integer :x_coordinate
      t.integer :y_coordinate
      t.string :title
      t.string :category_name
      t.integer :category_id
      t.integer :border_type
      t.boolean :collapsed
      t.references :owner, index: true

      t.timestamps null: true
    end
  end
end
