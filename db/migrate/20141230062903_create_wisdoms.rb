class CreateWisdoms < ActiveRecord::Migration
  def change
    create_table :wisdoms do |t|
      t.string :name
      t.text :wisdom
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
