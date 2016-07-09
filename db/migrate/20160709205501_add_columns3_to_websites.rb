class AddColumns3ToWebsites < ActiveRecord::Migration
  def change
    add_column :websites, :website_category, :string
  end
end
