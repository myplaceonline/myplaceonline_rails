class AddCategoryFiltertextCampLocations < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("camp_locations", "boondocking")
  end
end
