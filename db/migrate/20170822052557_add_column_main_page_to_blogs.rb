class AddColumnMainPageToBlogs < ActiveRecord::Migration[5.1]
  def change
    add_reference :blogs, :main_post, references: :blog_posts, foreign_key: false
    add_foreign_key :blogs, :blog_posts, column: :main_post_id
  end
end
