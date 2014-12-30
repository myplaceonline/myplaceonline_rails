class AddCategoryWisdom < ActiveRecord::Migration
  def change
    Category.create(name: "wisdoms", link: "wisdoms", position: 0, parent: Category.find_by_name("meaning"))
  end
end
