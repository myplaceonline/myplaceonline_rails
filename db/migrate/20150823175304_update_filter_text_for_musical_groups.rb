class UpdateFilterTextForMusicalGroups < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("musical_groups", "musicians artists singers")
  end
end
