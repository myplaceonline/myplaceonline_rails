class AddCategoryMrobbles < ActiveRecord::Migration[5.2]
  def change
    Category.create(name: "mrobbles", link: "mrobbles", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/sound_wave.png")
  end
end
