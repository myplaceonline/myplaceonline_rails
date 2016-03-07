class AddCategoryFiltertextServers < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("computers", "servers")
  end
end
