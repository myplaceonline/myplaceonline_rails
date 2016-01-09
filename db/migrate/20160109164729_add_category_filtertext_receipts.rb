class AddCategoryFiltertextReceipts < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("receipts", "orders purchases")
  end
end
