class AddColumns2ToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :hours_per_week, :decimal, precision: 10, scale: 2
  end
end
