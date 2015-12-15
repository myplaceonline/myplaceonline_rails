class CreateToDos < ActiveRecord::Migration
  def change
    create_table :to_dos do |t|
      t.string :short_description
      t.text :notes
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
