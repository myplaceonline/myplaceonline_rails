class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :name
      t.string :url
      t.references :identity, index: true

      t.timestamps
    end
  end
end
