class AddCategoryFiltertextToMrobbles < ActiveRecord::Migration[5.2]
  def change
    Myp.migration_add_filtertext("mrobbles", "scrobble video audio podcast mp3 media")
  end
end
