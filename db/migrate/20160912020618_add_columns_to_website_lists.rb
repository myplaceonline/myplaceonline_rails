class AddColumnsToWebsiteLists < ActiveRecord::Migration
  def change
    add_column :website_lists, :disable_autoload, :boolean
  end
end
