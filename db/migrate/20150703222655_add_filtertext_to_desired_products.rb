class AddFiltertextToDesiredProducts < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("desired_products", "buy purchase things")
  end
end
