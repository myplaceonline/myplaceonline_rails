class CreateMovieTheaters < ActiveRecord::Migration
  def change
    create_table :movie_theaters do |t|
      t.string :theater_name
      t.references :location, index: true
      t.integer :visit_count
      t.references :owner, index: true

      t.timestamps
    end
  end
end
