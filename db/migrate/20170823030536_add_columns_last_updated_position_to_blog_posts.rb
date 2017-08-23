class AddColumnsLastUpdatedPositionToBlogPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :blog_posts, :last_updated_bottom, :boolean
  end
end
