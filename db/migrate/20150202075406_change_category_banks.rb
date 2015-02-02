class ChangeCategoryBanks < ActiveRecord::Migration
  def change
    cat = Category.where(name: "banks").take!
    cat.name = "companies"
    cat.link = "companies"
    cat.save
  end
end
