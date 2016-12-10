class AddCategoryFiltertextInsurances < ActiveRecord::Migration[5.0]
  def change
    Myp.migration_add_filtertext("dental_insurances", "health medical")
    Myp.migration_add_filtertext("health_insurances", "medical")
  end
end
