class CreateDatingProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :dating_profiles do |t|
      t.string :dating_profile_name
      t.text :about_me
      t.text :looking_for
      t.text :movies
      t.text :books
      t.text :music
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
