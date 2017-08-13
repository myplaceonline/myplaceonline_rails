class AddCategoryBlogs < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "blogs", link: "blogs", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/blogs.png")
  end
end
