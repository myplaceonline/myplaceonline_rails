class AddColumnPostDateToBlogPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :blog_posts, :post_date, :datetime
  end
end
