class AddCategoryFiltertextSteakhouses < ActiveRecord::Migration[6.1]
  def change
    Myp.migration_add_filtertext("steakhouses", "meat bbq barbecue restaurant food ribeye")
    Myp.migration_add_filtertext("barbecues", "meat steak")
  end
end
