class CreateWebsiteLists < ActiveRecord::Migration
  def change
    create_table :website_lists do |t|
      t.string :website_list_name
      t.text :notes
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
