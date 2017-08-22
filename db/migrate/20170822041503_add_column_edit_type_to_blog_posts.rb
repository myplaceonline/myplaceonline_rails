class AddColumnEditTypeToBlogPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :blog_posts, :edit_type, :integer
  end
end
