class CreateHappyThings < ActiveRecord::Migration
  def change
    create_table :happy_things do |t|
      t.string :happy_thing_name
      t.text :notes
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
