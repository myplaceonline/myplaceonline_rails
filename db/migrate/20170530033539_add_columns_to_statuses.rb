class AddColumnsToStatuses < ActiveRecord::Migration[5.1]
  def change
    add_column :statuses, :stoic_ailments, :string
    add_column :statuses, :stoic_failings, :string
    add_column :statuses, :stoic_failed, :string
    add_column :statuses, :stoic_duties, :string
    add_column :statuses, :stoic_improvement, :string
    add_column :statuses, :stoic_faults, :string
  end
end
