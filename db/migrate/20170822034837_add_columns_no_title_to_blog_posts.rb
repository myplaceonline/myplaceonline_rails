class AddColumnsNoTitleToBlogPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :blog_posts, :hide_title, :boolean
    add_column :blog_posts, :import_original, :text
  end
end
