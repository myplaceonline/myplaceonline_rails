class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :name
      t.datetime :watched
      t.string :url
      t.references :identity, index: true

      t.timestamps
    end
  end
end
