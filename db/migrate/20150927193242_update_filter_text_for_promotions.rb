class UpdateFilterTextForPromotions < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("promotions", "vouchers credits")
  end
end
