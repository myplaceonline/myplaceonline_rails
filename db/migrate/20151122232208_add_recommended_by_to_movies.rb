class AddRecommendedByToMovies < ActiveRecord::Migration
  def change
    add_reference :movies, :recommender, index: true
  end
end
