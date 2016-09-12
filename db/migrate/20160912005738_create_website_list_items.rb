class CreateWebsiteListItems < ActiveRecord::Migration
  def change
    create_table :website_list_items do |t|
      t.references :website_list, index: true, foreign_key: true
      t.references :website, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
