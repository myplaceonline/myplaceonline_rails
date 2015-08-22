class UpdateFilterTextForDoctors < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("doctors", "dentists")
  end
end
