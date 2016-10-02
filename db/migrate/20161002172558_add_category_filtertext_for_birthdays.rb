class AddCategoryFiltertextForBirthdays < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("contacts", "birthdays")
  end
end
