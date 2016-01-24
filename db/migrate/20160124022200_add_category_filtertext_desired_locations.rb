class AddCategoryFiltertextDesiredLocations < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("desired_locations", "places go")
  end
end
