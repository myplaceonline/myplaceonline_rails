class AddCategoryFiltertextSchools < ActiveRecord::Migration[5.1]
  def change
    Myp.migration_add_filtertext("educations", "school")
  end
end
