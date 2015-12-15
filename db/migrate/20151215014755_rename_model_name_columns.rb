class RenameModelNameColumns < ActiveRecord::Migration
  def change
    rename_column :due_items, :model_name, :myp_model_name
    rename_column :complete_due_items, :model_name, :myp_model_name
    rename_column :snoozed_due_items, :model_name, :myp_model_name
    rename_column :phones, :model_name, :phone_model_name
    rename_column :shares, :model_name, :myp_model_name
  end
end
