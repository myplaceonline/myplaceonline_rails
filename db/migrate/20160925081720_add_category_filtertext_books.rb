class AddCategoryFiltertextBooks < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("books", "comics")
  end
end
