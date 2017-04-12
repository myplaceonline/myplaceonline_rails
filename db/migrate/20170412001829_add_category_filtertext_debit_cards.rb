class AddCategoryFiltertextDebitCards < ActiveRecord::Migration[5.0]
  def change
    Myp.migration_add_filtertext("credit_cards", "debit")
  end
end
