class ChangeActionColumns < ActiveRecord::Migration[5.1]
  def change
    rename_column :website_domain_myplets, :action, :action_string
    rename_column :myplets, :action, :action_string
  end
end
