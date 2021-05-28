class AddCategoryFiltertextMediaDumpsMemes < ActiveRecord::Migration[6.1]
  def change
    Myp.migration_add_filtertext("media_dumps", "memes")
  end
end
