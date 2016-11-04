class AddCategoryFiltertextItems < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("items", "property things")
  end
end
