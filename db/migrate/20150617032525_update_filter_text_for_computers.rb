class UpdateFilterTextForComputers < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("computers", "laptops")
  end
end
