class AddCategoryFiltertextStories < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("stories", "what doing new happening")
  end
end
