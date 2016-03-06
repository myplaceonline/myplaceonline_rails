class AddReviewToBooks < ActiveRecord::Migration
  def change
    add_column :books, :review, :text
  end
end
