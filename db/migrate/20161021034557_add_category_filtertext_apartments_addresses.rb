class AddCategoryFiltertextApartmentsAddresses < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("apartments", "addresses")
  end
end
