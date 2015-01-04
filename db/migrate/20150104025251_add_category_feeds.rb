class AddCategoryFeeds < ActiveRecord::Migration
  def change
    Category.create(name: "feeds", link: "feeds", position: 0, parent: Category.find_by_name("order"))
  end
end
