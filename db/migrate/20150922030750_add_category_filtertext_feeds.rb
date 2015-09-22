class AddCategoryFiltertextFeeds < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("feeds", "rss atom")
  end
end
