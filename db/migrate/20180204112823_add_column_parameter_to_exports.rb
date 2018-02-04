class AddColumnParameterToExports < ActiveRecord::Migration[5.1]
  def change
    add_column :exports, :parameter, :string
  end
end
