class AddColumnWorkTimePercentageToJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :work_time_percentage, :decimal, precision: 10, scale: 2
  end
end
