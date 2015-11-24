class AddCategoryFiltertextLifeGoals < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("life_goals", "intentions do desire")
  end
end
