class AddCategoryLoyaltyPrograms < ActiveRecord::Migration
  def change
    Category.create(name: "reward_programs", link: "reward_programs", position: 0, parent: Category.find_by_name("finance"), icon: "FatCow_Icons16x16/teddy_bear.png")
  end
end
