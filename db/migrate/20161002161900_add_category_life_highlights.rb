class AddCategoryLifeHighlights < ActiveRecord::Migration
  def change
    Category.create(name: "life_highlights", link: "life_highlights", position: 0, parent: Category.find_by_name("meaning"), icon: "famfamfam/newspaper.png")
  end
end
