class AddCategoryCrontabs < ActiveRecord::Migration[5.2]
  def change
    Category.create(name: "crontabs", link: "crontabs", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/time.png", user_type_mask: 1)
  end
end
