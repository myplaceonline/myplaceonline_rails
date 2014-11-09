class CreatePasswords < ActiveRecord::Migration
  def change
    create_table :passwords do |t|
      t.string :name
      t.string :user
      t.string :password
      t.string :url
      t.text :notes
      t.references :identity, index: true

      t.timestamps
    end
  end
end
