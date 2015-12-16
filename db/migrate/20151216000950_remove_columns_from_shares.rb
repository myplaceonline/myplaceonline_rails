class RemoveColumnsFromShares < ActiveRecord::Migration
  def change
    remove_column :shares, :myp_model_name
    remove_column :shares, :model_id
  end
end
