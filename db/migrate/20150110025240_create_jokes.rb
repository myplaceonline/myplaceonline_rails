class CreateJokes < ActiveRecord::Migration
  def change
    create_table :jokes do |t|
      t.string :name
      t.text :joke
      t.string :source
      t.references :identity, index: true

      t.timestamps
    end
  end
end
