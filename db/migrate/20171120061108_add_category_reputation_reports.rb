class AddCategoryReputationReports < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "reputation_reports", link: "reputation_reports", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/lighthouse.png")
  end
end
