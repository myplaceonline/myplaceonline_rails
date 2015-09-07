class AddFeelingToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :feeling, :integer
  end
end
