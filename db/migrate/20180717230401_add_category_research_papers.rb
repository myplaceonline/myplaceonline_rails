class AddCategoryResearchPapers < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "research_papers", link: "research_papers", position: 0, parent: Category.find_by_name("meaning"), icon: "FatCow_Icons16x16/research.png")
  end
end
