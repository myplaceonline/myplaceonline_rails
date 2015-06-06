class AddCategoryJobs < ActiveRecord::Migration
  def change
    Category.create(name: "jobs", link: "jobs", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/reseller_account.png")
  end
end
