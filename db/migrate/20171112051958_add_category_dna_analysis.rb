class AddCategoryDnaAnalysis < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "dna_analyses", link: "dna_analyses", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/molecule.png")
  end
end
