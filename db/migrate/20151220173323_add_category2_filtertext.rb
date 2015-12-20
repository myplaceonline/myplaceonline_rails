class AddCategory2Filtertext < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("bars", "restaurants")
  end
end
