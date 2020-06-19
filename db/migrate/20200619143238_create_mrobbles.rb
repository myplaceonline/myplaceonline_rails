class CreateMrobbles < ActiveRecord::Migration[5.2]
  def change
    create_table :mrobbles do |t|
      t.string :mrobble_name
      t.string :mrobble_link
      t.string :stopped_watching_time
      t.boolean :finished
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.boolean :is_public
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
