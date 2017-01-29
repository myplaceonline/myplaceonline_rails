class AddCategoryFiltertextPoetry < ActiveRecord::Migration[5.0]
  def change
    Myp.migration_add_filtertext("poems", "poetry")
  end
end
