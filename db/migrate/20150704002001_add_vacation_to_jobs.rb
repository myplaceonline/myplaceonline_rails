class AddVacationToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :days_holiday, :integer
    add_column :jobs, :days_vacation, :integer
  end
end
