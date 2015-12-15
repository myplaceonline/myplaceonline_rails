class CreateMusicalGroups < ActiveRecord::Migration
  def change
    create_table :musical_groups do |t|
      t.string :musical_group_name
      t.text :notes
      t.datetime :listened
      t.integer :rating
      t.boolean :awesome
      t.boolean :secret
      t.references :owner, index: true

      t.timestamps null: true
    end
  end
end
