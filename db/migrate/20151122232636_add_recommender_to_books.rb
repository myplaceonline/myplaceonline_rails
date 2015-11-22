class AddRecommenderToBooks < ActiveRecord::Migration
  def change
    add_reference :books, :recommender, index: true
  end
end
