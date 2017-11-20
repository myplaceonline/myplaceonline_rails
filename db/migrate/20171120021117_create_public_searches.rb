class CreatePublicSearches < ActiveRecord::Migration[5.1]
  def change
    create_table :public_searches do |t|
      t.string :category
      t.references :identity, foreign_key: true
      t.datetime :archived

      t.timestamps
    end
  end
end
