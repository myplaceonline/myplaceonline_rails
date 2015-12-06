class ChangePasswordWebsiteLength < ActiveRecord::Migration
  def change
    change_column :passwords, :url, :string,  :limit => 2000
    change_column :websites, :url, :string,  :limit => 2000
  end
end
