class AddCategoryAnnuities < ActiveRecord::Migration
  def change
    Category.create(name: "annuities", link: "annuities", position: 0, parent: Category.find_by_name("finance"), icon: "FatCow_Icons16x16/credit.png")
  end
end
