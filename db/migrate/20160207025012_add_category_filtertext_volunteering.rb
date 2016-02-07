class AddCategoryFiltertextVolunteering < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("volunteering_activities", "intentions non-profit good do mentor donate")
  end
end
