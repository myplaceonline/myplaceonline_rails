class AddCategoryCreditReports < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "credit_reports", link: "credit_reports", position: 0, parent: Category.find_by_name("finance"), icon: "FatCow_Icons16x16/report_magnify.png")
  end
end
