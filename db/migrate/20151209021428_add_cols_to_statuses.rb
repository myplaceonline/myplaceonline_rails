class AddColsToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :status1, :string
    add_column :statuses, :status2, :string
    add_column :statuses, :status3, :string
  end
end
