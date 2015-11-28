class AddCategoryMovieTheaters < ActiveRecord::Migration
  def change
    Category.create(name: "movie_theaters", link: "movie_theaters", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/movies.png")
  end
end
