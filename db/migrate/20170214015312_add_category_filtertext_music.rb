class AddCategoryFiltertextMusic < ActiveRecord::Migration[5.0]
  def change
    Myp.migration_add_filtertext("concerts", "music")
    Myp.migration_add_filtertext("media_dumps", "music")
    Myp.migration_add_filtertext("playlists", "music")
    Myp.migration_add_filtertext("songs", "music")
  end
end
