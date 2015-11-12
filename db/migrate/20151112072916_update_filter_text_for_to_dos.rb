class UpdateFilterTextForToDos < ActiveRecord::Migration
  def change
    Myp.migration_add_filtertext("to_dos", "to dos")
  end
end
