class AddColumnToPhones < ActiveRecord::Migration
  def change
    add_column :phone_files, :position, :integer
  end
end
