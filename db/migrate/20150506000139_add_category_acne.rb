class AddCategoryAcne < ActiveRecord::Migration
  def change
    Category.create(name: "acne_measurements", link: "acne_measurements", position: 0, parent: Category.find_by_name("health"))
  end
end
