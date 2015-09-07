class CreateShoppingListItems < ActiveRecord::Migration
  def change
    create_table :shopping_list_items do |t|
      t.references :owner, index: true
      t.references :shopping_list, index: true
      t.string :shopping_list_item_name
      t.integer :position

      t.timestamps
    end
  end
end
