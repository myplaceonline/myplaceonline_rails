class CreateListItems < ActiveRecord::Migration
  def change
    create_table :list_items do |t|
      t.string :name
      t.references :list, index: true

      t.timestamps null: true
    end
  end
end
