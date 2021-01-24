class AddColumnRequiresLoginToBlogPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :blog_posts, :requireslogin, :boolean
  end
end
