class AddColumnsToWebsites < ActiveRecord::Migration
  def change
    add_column :websites, :to_visit, :boolean
  end
end
