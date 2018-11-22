class AddColumnReverseToBlogs < ActiveRecord::Migration[5.1]
  def change
    add_column :blogs, :reverse, :boolean
  end
end
