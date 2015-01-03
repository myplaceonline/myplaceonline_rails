class AddCategoryAccomplishments < ActiveRecord::Migration
  def change
    Category.create(name: "accomplishments", link: "accomplishments", position: 0, parent: Category.find_by_name("meaning"))
  end
end
