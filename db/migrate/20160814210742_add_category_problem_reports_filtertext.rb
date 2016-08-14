class AddCategoryProblemReportsFiltertext < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("problem_reports", "complaint concern incident observation warning feedback suggestion bug issue")
  end
end
