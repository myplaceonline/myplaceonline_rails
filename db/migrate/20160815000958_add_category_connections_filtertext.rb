class AddCategoryConnectionsFiltertext < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("connections", "friends relationships")
  end
end
