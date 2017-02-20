class AddColumnToInjuries < ActiveRecord::Migration[5.0]
  def change
    add_column :injuries, :notes, :text
  end
end
