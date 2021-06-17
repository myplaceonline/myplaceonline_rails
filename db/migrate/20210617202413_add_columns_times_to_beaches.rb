class AddColumnsTimesToBeaches < ActiveRecord::Migration[6.1]
  def change
    add_column :beaches, :open_time, :text
    add_column :beaches, :close_time, :text
  end
end
