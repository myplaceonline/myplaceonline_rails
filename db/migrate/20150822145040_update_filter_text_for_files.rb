class UpdateFilterTextForFiles < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("files", "pictures")
  end
end
