class AddCategoryFiltertextQuests < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("quests", "learn education analysis exploration inquiry investigation probe experiment")
  end
end
