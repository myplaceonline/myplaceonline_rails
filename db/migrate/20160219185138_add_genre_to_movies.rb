class AddGenreToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :genre, :string
  end
end
