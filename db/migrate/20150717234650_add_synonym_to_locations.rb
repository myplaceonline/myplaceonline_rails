class AddSynonymToLocations < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("locations", "addresses")
  end
end
