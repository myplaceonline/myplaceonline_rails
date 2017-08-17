class AddCategoryTranslations < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "translations", link: "translations", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/translation_tool_tip.png")
  end
end
