class CreateBasketballCourtFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :basketball_court_files do |t|
      t.references :basketball_court, foreign_key: true
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position
      t.boolean :is_public

      t.timestamps
    end
  end
end
