class AddCategoryFiltertextCharities < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("charities", "non profit volunteer help foundation gift philanthropy donate")
  end
end
