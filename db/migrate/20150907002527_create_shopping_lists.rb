class CreateShoppingLists < ActiveRecord::Migration
  def change
    create_table :shopping_lists do |t|
      t.string :shopping_list_name
      t.references :owner, index: true

      t.timestamps null: true
    end
  end
end
