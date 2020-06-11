class AddCategoryFiltertextBoondockingsCamping < ActiveRecord::Migration[5.2]
  def change
    Myp.migration_add_filtertext("boondockings", "camping overnight location")
  end
end
