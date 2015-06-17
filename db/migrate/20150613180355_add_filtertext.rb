class AddFiltertext < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("promotions", "coupons gifts")
    Myp.migration_add_filtertext("reward_programs", "loyalty")
  end
end
