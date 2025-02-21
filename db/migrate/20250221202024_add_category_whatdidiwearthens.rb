class AddCategoryWhatdidiwearthens < ActiveRecord::Migration[6.1]
  def change
    Category.create(name: "whatdidiwearthens", link: "whatdidiwearthens", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/shirt_polo.png")
  end
end
