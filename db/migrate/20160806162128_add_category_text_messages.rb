class AddCategoryTextMessages < ActiveRecord::Migration
  def change
    Category.create(name: "text_messages", link: "text_messages", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/phone_sound.png")
  end
end
