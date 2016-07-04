class AddColumnToWebsites < ActiveRecord::Migration
  def change
    add_column :websites, :notes, :text
  end
end
