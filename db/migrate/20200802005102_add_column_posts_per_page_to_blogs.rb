class AddColumnPostsPerPageToBlogs < ActiveRecord::Migration[5.2]
  def change
    add_column :blogs, :posts_per_page, :integer
  end
end
