class CreateWebsitePasswords < ActiveRecord::Migration
  def change
    create_table :website_passwords do |t|
      t.references :website, index: true, foreign_key: true
      t.references :password, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
