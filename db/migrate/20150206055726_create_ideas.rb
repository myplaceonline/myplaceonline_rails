class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.string :name
      t.text :idea
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
