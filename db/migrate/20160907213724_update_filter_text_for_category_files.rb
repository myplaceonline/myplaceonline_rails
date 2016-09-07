class UpdateFilterTextForCategoryFiles < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("files", "images gifs")
  end
end
