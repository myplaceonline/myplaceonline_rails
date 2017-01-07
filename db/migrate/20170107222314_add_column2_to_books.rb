class AddColumn2ToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :acquired, :date
  end
end
