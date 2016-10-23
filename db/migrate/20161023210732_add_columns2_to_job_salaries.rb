class AddColumns2ToJobSalaries < ActiveRecord::Migration
  def change
    add_column :job_salaries, :hours_per_week, :decimal, precision: 10, scale: 2
  end
end
