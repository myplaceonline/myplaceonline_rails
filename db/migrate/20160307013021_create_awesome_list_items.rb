class CreateAwesomeListItems < ActiveRecord::Migration
  def change
    create_table :awesome_list_items do |t|
      t.string :item_name
      t.references :awesome_list, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
