class AddCategoryFiltertextWisdom < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("wisdoms", "learn")
  end
end
