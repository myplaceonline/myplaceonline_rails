class AddColumns2ToWebsiteLists < ActiveRecord::Migration
  def change
    add_column :website_lists, :iframe_height, :integer
  end
end
