class AddColumnsToJobReviews < ActiveRecord::Migration
  def change
    add_column :job_reviews, :self_evaluation, :text
  end
end
