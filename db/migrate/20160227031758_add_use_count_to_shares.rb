class AddUseCountToShares < ActiveRecord::Migration
  def change
    add_column :shares, :use_count, :integer
    add_column :shares, :max_use_count, :integer
  end
end
