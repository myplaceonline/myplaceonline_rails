class AddCategoryFiltertextHeartRateMeasurements < ActiveRecord::Migration[5.2]
  def change
    Myp.migration_add_filtertext("heart_rates", "pulse")
  end
end
