class AddCategoryActivities < ActiveRecord::Migration
  def change
    Category.create(name: "activities", link: "activities", position: 0, parent: Category.find_by_name("joy"))
  end
end
