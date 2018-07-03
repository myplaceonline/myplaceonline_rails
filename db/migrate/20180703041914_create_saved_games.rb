class CreateSavedGames < ActiveRecord::Migration[5.1]
  def change
    create_table :saved_games do |t|
      t.string :game_name
      t.datetime :game_time
      t.references :contact, foreign_key: true
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
