class AddCategory3Filtertext < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("treks", "hikes")
  end
end
