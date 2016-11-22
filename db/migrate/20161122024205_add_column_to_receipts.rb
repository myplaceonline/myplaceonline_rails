class AddColumnToReceipts < ActiveRecord::Migration
  def change
    add_column :receipt_files, :position, :integer
  end
end
