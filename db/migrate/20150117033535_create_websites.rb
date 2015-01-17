class CreateWebsites < ActiveRecord::Migration
  def change
    create_table :websites do |t|
      t.string :title
      t.string :url
      t.references :identity, index: true

      t.timestamps
    end
  end
end
