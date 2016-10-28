class UpdateFilterTextForCategoryDocuments < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("documents", "important")
  end
end
